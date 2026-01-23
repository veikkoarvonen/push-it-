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
