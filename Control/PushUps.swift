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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let camTap = UITapGestureRecognizer(target: self, action: #selector(handleCamTap))
        cameraIconView.addGestureRecognizer(camTap)
        cameraIconView.isUserInteractionEnabled = true
    }
    
    @objc func handleCamTap() {
        print("Camera tapped!")
    }


}
