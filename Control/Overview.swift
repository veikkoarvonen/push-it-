//
//  Overview.swift
//  Push It!
//
//  Created by Veikko Arvonen on 18.1.2026.
//

import UIKit

class OverviewVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tabBarController?.tabBar.tintColor = .white
        tabBarController?.tabBar.unselectedItemTintColor = .white.withAlphaComponent(0.6)
    }


}
