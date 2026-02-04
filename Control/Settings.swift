//
//  Settings.swift
//  Push It!
//
//  Created by Veikko Arvonen on 19.1.2026.
//

import UIKit

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
        
    }


}

extension SettingsVC {
    
    private func setUI() {
        
        let bgImage = UIImageView(image: UIImage(named: C.bgView))
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bgImage)
        
        NSLayoutConstraint.activate([
            bgImage.topAnchor.constraint(equalTo: view.topAnchor),
            bgImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
}
