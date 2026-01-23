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
        finishCameraSession()
    }
    
    @objc func handleCamTap() {
        if !cameraIsActive {
            cameraManager.startPreview(in: cameraLayerView) { [weak self] result in
                switch result {
                case .success:
                    // optional: update UI (button title, status label, etc.)
                    guard let self else { return }
                    self.cameraIsActive = true
                    self.updateUIState(cameraIsActive: cameraIsActive)
                    
                    pushUpCounterLabel.text = "\(requiredPushUps)"
                    
                    cameraManager.onFrame = { [weak self] pixelBuffer in
                        guard let self, self.cameraIsActive else { return }
                        pushUpDetector.reset()
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
            finishCameraSession()
        }
    }
    
    private func finishCameraSession() {
        
        guard cameraIsActive else { return }
        
        print("Finishing camera session, User completed \(pushUpDetector.count) push ups")
        
        if pushUpDetector.count > 0 { coreData.createWorkout(reps: Int16(pushUpDetector.count), date: Date()) }
        
        cameraManager.stopPreview()
        pushUpDetector.reset()
        cameraIsActive = false
        updateUIState(cameraIsActive: cameraIsActive)
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
        
        if let savedValue = UserDefaults.standard.value(forKey: C.userDefaultValues.pushUps) as? Int {
            requiredPushUps = savedValue
        }
        
        pushUpDetector.onUpdate = { [weak self] count, status, angle in
            DispatchQueue.main.async {
                
                guard let self else { return }
                
                let labelValue = self.requiredPushUps - count
                
                self.pushUpCounterLabel.text = "\(labelValue)"
                
                if labelValue <= 0 { self.finishCameraSession() }
                
                var statusMessage: String {
                    switch status {
                    case .visionError: return "Vision error"
                    case .bodyNotVisible: return "Move to push up position with whole body visible"
                    case .detecting: return "Move to push up position with whole body visible"
                    case .up, .down, .moving: return "Body detected, perform push ups"
                    }
                }
                
                self.pushUpStatusLabel.text = statusMessage
                
               
                //print("Reps:", count, "Status:", status, "Angle:", angle)
                
            }
        }
    }
    
    private func addTextShadow(to label: UILabel) {
        label.shadowColor = UIColor.black
        label.shadowOffset = CGSize(width: 2, height: 2)
    }
    
}
