//
//  PushUps.swift
//  Push It!
//
//  Created by Veikko Arvonen on 19.1.2026.
//

import UIKit

class PushUpsVC: UIViewController {

    @IBOutlet weak var cameraLayerView: UIView!
    @IBOutlet weak var cameraIconView: UIImageView!
    @IBOutlet weak var pushUpCounterLabel: UILabel!
    @IBOutlet weak var pushUpsRemainingLabel: UILabel!
    @IBOutlet weak var pushUpsInstructionLabel: UILabel!
    @IBOutlet weak var pushUpStatusLabel: UILabel!
    
    //camera preview
    private let cameraManager = CameraPreviewManager()
    private var cameraIsActive: Bool = false
    
    //Push up detection
    private let pushUpDetector = PushUpDetector()
    private var lastVisionTime = CACurrentMediaTime()
    private let visionInterval: CFTimeInterval = 0.10 // ~10 FPS
    private var requiredPushUps: Int = 20 //Default value
    
    let coreData = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard cameraIsActive else { return }
        print("Push up view about to disappear, ending camera session")
        finishCameraSession(withAlert: false)
    }
    
    @objc func handleCamTap() {
        
        if C.testPushUpCreationWithoutCamera {
            print("Testing push up creation without camera, not starting camera session")
            displayPushUpCompletionAlert(title: "Congratulations!", completedPushUps: 50)
            
            let targetDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
            
            coreData.createWorkout(reps: 100, date: targetDate)
            UserDefaults.standard.set(true, forKey: C.userDefaultValues.shouldUpdateSheet)
            UserDefaults.standard.set(true, forKey: C.userDefaultValues.shouldUpdateTokens)
            return
        }
        
        
        if !cameraIsActive {
            cameraManager.startPreview(in: cameraLayerView) { [weak self] result in
                switch result {
                case .success:
                    // optional: update UI (button title, status label, etc.)
                    guard let self else { return }
                    self.cameraIsActive = true
                    self.pushUpDetector.reset()
                    self.updateUIState(cameraIsActive: cameraIsActive)
                    
                    if let savedValue = UserDefaults.standard.value(forKey: C.userDefaultValues.pushUps) as? Int {
                        requiredPushUps = savedValue
                    } else {
                        requiredPushUps = 20
                    }
                    
                    pushUpCounterLabel.text = "\(requiredPushUps)"
                    
                    cameraManager.onFrame = { [weak self] pixelBuffer in
                        guard let self, self.cameraIsActive else { return }
                        let now = CACurrentMediaTime()
                        guard now - self.lastVisionTime >= self.visionInterval else { return }
                        self.lastVisionTime = now
                        self.pushUpDetector.process(pixelBuffer: pixelBuffer)
                    }
                    


                case .failure(let error):
                    self?.showError(title: "Camera", message: error.localizedDescription)
                }
            }
        } else {
            finishCameraSession(withAlert: true)
        }
    }
    
    private func finishCameraSession(withAlert: Bool) {
        
        guard cameraIsActive else { return }
        
        print("Finishing camera session, User completed \(pushUpDetector.count) push ups")
        
        cameraManager.stopPreview()
        pushUpDetector.reset()
        cameraIsActive = false
        updateUIState(cameraIsActive: cameraIsActive)
        
        if pushUpDetector.count > 0 {
            coreData.createWorkout(reps: Int16(pushUpDetector.count), date: Date())
            UserDefaults.standard.set(true, forKey: C.userDefaultValues.shouldUpdateSheet)
            UserDefaults.standard.set(true, forKey: C.userDefaultValues.shouldUpdateTokens)
            if withAlert { displayPushUpCompletionAlert(title: "Congratulations!", completedPushUps: pushUpDetector.count) }
        }
    }


}

//MARK: - Camera & Push up logic
extension PushUpsVC {
    
    private func updateUIState(cameraIsActive: Bool) {
        pushUpsInstructionLabel.isHidden = cameraIsActive
        pushUpCounterLabel.isHidden = !cameraIsActive
        pushUpsRemainingLabel.isHidden = !cameraIsActive
        cameraLayerView.isHidden = !cameraIsActive
    }
    
    private func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func displayPushUpCompletionAlert(title: String, completedPushUps: Int) {
        
        let savedPushUpValue = UserDefaults.standard.value(forKey: C.userDefaultValues.pushUps) as? Int ?? 20
        
        let savedMinutesValue = UserDefaults.standard.value(forKey: C.userDefaultValues.minutes) as? Int ?? 20
        
        let pushUpPercentage = Double(completedPushUps) / Double(savedPushUpValue)
        let earnedMinutes = pushUpPercentage * Double(savedMinutesValue)
        let roundedMinutes = Int(earnedMinutes.rounded())
        
        print("Saved push up value is \(savedPushUpValue). Saved minutes value is \(savedMinutesValue). Push up percentage is \(pushUpPercentage) since user completed \(completedPushUps) push ups. This grants user \(earnedMinutes) minutes of screentime which is \(roundedMinutes) when rounded")
        
        
        let fullMessage = "You compeleted \(completedPushUps) push ups! This earns you \(roundedMinutes) minutes of screentime."

            let alert = UIAlertController(
                title: title,
                message: fullMessage,
                preferredStyle: .alert
            )

            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)

            present(alert, animated: true)
        
    }
    
}

//MARK: - UI
extension PushUpsVC {
    
    private func prepareUI() {
        let camTap = UITapGestureRecognizer(target: self, action: #selector(handleCamTap))
        cameraIconView.addGestureRecognizer(camTap)
        cameraIconView.isUserInteractionEnabled = true
        updateUIState(cameraIsActive: cameraIsActive)
        
        addTextShadow(to: pushUpStatusLabel)
        addTextShadow(to: pushUpCounterLabel)
        addTextShadow(to: pushUpsRemainingLabel)
        
        
        
        pushUpDetector.onUpdate = { [weak self] count, status, angle in
            DispatchQueue.main.async {
                
                guard let self else { return }
                
                let labelValue = self.requiredPushUps - count
                
                self.pushUpCounterLabel.text = "\(labelValue)"
                
                if labelValue <= 0 { self.finishCameraSession(withAlert: true) }
                
                var statusMessage: String {
                    switch status {
                    case .visionError: return "Vision error"
                    case .bodyNotVisible: return "Move to push up position with whole body visible"
                    case .detecting: return "Move to push up position with whole body visible"
                    case .up, .down, .moving: return "Body detected, perform push ups"
                    }
                }
                
                self.pushUpStatusLabel.text = statusMessage
                
               
                print("Reps:", count, "Status:", status, "Angle:", angle)
                
            }
        }
    }
    
    private func addTextShadow(to label: UILabel) {
        label.shadowColor = UIColor.black
        label.shadowOffset = CGSize(width: 2, height: 2)
    }
    
}
