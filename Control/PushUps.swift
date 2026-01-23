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
    
    private let cameraManager = CameraPreviewManager()
    private var cameraIsActive: Bool = false
    private let pushUpDetector = PushUpDetector()
    private var lastVisionTime = CACurrentMediaTime()
    private let visionInterval: CFTimeInterval = 0.10 // ~10 FPS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManager.stopPreview()
        cameraIsActive = false
        updateUIState(cameraIsActive: cameraIsActive)
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
            cameraManager.stopPreview()
            cameraIsActive = false
            updateUIState(cameraIsActive: cameraIsActive)
        }
    }
    
    private func prepareUI() {
        let camTap = UITapGestureRecognizer(target: self, action: #selector(handleCamTap))
        cameraIconView.addGestureRecognizer(camTap)
        cameraIconView.isUserInteractionEnabled = true
        updateUIState(cameraIsActive: cameraIsActive)
        
        pushUpDetector.onUpdate = { [weak self] count, status in
            DispatchQueue.main.async {
                // Add these labels to your UIElements struct if you haven’t yet
                // Example:
                // self?.uiElements.pushUpCountLabel.text = "\(count)"
                // self?.uiElements.statusLabel.text = status

                // If you don't have labels yet, at least print:
                print("Reps:", count, "Status:", status)
            }
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
    
}
