//
//  Settings.swift
//  Push It!
//
//  Created by Veikko Arvonen on 19.1.2026.
//

import UIKit

class SettingsVC: UIViewController {
    
    let builder = UIBuilder()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
        
    }
    
    @objc private func openPrivacyPolicy() {
        guard let url = URL(string: "https://www.liikax.fi/privacypolicyapp") else { return }
        UIApplication.shared.open(url)
    }

    @objc private func openTermsOfUse() {
        guard let url = URL(string: "https://www.liikax.fi/termsofuseapp") else { return }
        UIApplication.shared.open(url)
    }



}

extension SettingsVC {
    
    private func setUI() {
        
//MARK: - Header Container
        
        let bgImage = UIImageView(image: UIImage(named: C.bgView))
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bgImage)
        
        NSLayoutConstraint.activate([
            bgImage.topAnchor.constraint(equalTo: view.topAnchor),
            bgImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let bgView = UIView()
        bgView.backgroundColor = C.testUIwithBackgroundColor ? .black.withAlphaComponent(0.5) : .clear
        bgView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bgView)
        
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bgView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let headerContainer = UIView()
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.backgroundColor = C.testUIwithBackgroundColor ? .red.withAlphaComponent(0.5) : .clear
        bgView.addSubview(headerContainer)
        
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: bgView.topAnchor),
            headerContainer.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
            headerContainer.heightAnchor.constraint(equalToConstant: 100.0)
        ])
        
        let decorationView = UIView()
        decorationView.translatesAutoresizingMaskIntoConstraints = false
        decorationView.backgroundColor = .black
        headerContainer.addSubview(decorationView)
        
        NSLayoutConstraint.activate([
            decorationView.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 60.0),
            decorationView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 30.0),
            decorationView.widthAnchor.constraint(equalToConstant: 200.0),
            decorationView.heightAnchor.constraint(equalToConstant: 20.0)
        ])
        
        let header = UILabel()
        builder.styleHeader(header: header, text: "Settings")
        header.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(header)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 30.0),
            header.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 30.0),
            header.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -30.0),
            header.heightAnchor.constraint(equalToConstant: 40.0)
        ])
        
//MARK: - Containers
        
        let container1 = UIView()
        container1.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(container1)
        
        NSLayoutConstraint.activate([
            container1.topAnchor.constraint(equalTo: headerContainer.bottomAnchor),
            container1.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            container1.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
            container1.heightAnchor.constraint(equalToConstant: 70.0)
        ])
        
        let privacyPolicyButtonLabel = UILabel()
        builder.styleLabel(header: privacyPolicyButtonLabel, text: "Privacy Policy", fontSize: 25.0, textColor: .white, alignment: .left)
        container1.addSubview(privacyPolicyButtonLabel)
        privacyPolicyButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            privacyPolicyButtonLabel.topAnchor.constraint(equalTo: container1.topAnchor, constant: 10.0),
            privacyPolicyButtonLabel.leadingAnchor.constraint(equalTo: container1.leadingAnchor, constant: 30.0),
            privacyPolicyButtonLabel.trailingAnchor.constraint(equalTo: container1.trailingAnchor, constant: -30),
            privacyPolicyButtonLabel.bottomAnchor.constraint(equalTo: container1.bottomAnchor, constant: -10.0)
        ])
        
        privacyPolicyButtonLabel.isUserInteractionEnabled = true

        let privacyTap = UITapGestureRecognizer(
            target: self,
            action: #selector(openPrivacyPolicy)
        )
        privacyPolicyButtonLabel.addGestureRecognizer(privacyTap)

        
        let container2 = UIView()
        container2.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(container2)
        
        NSLayoutConstraint.activate([
            container2.topAnchor.constraint(equalTo: container1.bottomAnchor),
            container2.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            container2.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
            container2.heightAnchor.constraint(equalToConstant: 70.0)
        ])
        
        let termsLabel = UILabel()
        builder.styleLabel(header: termsLabel, text: "Terms Of Use", fontSize: 25.0, textColor: .white, alignment: .left)
        container2.addSubview(termsLabel)
        termsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            termsLabel.topAnchor.constraint(equalTo: container2.topAnchor, constant: 10.0),
            termsLabel.leadingAnchor.constraint(equalTo: container2.leadingAnchor, constant: 30.0),
            termsLabel.trailingAnchor.constraint(equalTo: container2.trailingAnchor, constant: -30),
            termsLabel.bottomAnchor.constraint(equalTo: container2.bottomAnchor, constant: -10.0)
        ])
        
        termsLabel.isUserInteractionEnabled = true

        let termsTap = UITapGestureRecognizer(
            target: self,
            action: #selector(openTermsOfUse)
        )
        termsLabel.addGestureRecognizer(termsTap)

        
    }
    
    
}
