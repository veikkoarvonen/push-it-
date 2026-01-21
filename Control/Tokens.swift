//
//  Tokens.swift
//  Push It!
//
//  Created by Veikko Arvonen on 19.1.2026.
//

import UIKit

class TokensVC: UIViewController {
    
    var hasSetUI: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
    }
    
    @objc private func tokenTapped(_ gesture: UITapGestureRecognizer) {
        guard let tappedView = gesture.view else { return }
        let index = tappedView.tag
        print("Token tapped at index:", index)

    }



}

extension TokensVC {
    
    private func setUI() {
        
        guard !hasSetUI else { return }
        hasSetUI = true
        
        let builder = UIBuilder()
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor(named: C.colors.gray1)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bgView)
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bgView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let headerContainer = UIView()
        headerContainer.backgroundColor = C.testUIwithBackgroundColor ? .red.withAlphaComponent(0.3) : .clear
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(headerContainer)
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: bgView.topAnchor),
            headerContainer.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
            headerContainer.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        let header = UILabel()
        builder.styleHeader(header: header, text: "Tokens")
        header.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(header)
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 30),
            header.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 30),
            header.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -30),
            header.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let decorationView = UIView()
        decorationView.backgroundColor = UIColor(named: C.colors.orange1)
        decorationView.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(decorationView)
        NSLayoutConstraint.activate([
            decorationView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: -10),
            decorationView.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 30),
            decorationView.widthAnchor.constraint(equalToConstant: 200),
            decorationView.heightAnchor.constraint(equalToConstant: 20)
            
        ])
        
        headerContainer.bringSubviewToFront(header)
        
        
        let tokenContainer = UIView()
        tokenContainer.backgroundColor = C.testUIwithBackgroundColor ? .yellow.withAlphaComponent(0.3): .clear
        tokenContainer.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(tokenContainer)
        NSLayoutConstraint.activate([
            tokenContainer.topAnchor.constraint(equalTo: headerContainer.bottomAnchor),
            tokenContainer.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            tokenContainer.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
            tokenContainer.bottomAnchor.constraint(equalTo: bgView.bottomAnchor)
        ])
        
        let rows = 4
        let columns = 3

        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.distribution = .fillEqually
        verticalStack.spacing = 25
        verticalStack.translatesAutoresizingMaskIntoConstraints = false

        tokenContainer.addSubview(verticalStack)

        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: tokenContainer.topAnchor, constant: 32),
            verticalStack.leadingAnchor.constraint(equalTo: tokenContainer.leadingAnchor, constant: 16),
            verticalStack.trailingAnchor.constraint(equalTo: tokenContainer.trailingAnchor, constant: -16),
            verticalStack.bottomAnchor.constraint(equalTo: tokenContainer.bottomAnchor, constant: -32)
        ])
        
        var tokenViews: [UIView] = []

        for _ in 0..<rows {
            let horizontalStack = UIStackView()
            horizontalStack.axis = .horizontal
            horizontalStack.distribution = .fillEqually
            horizontalStack.spacing = 25

            verticalStack.addArrangedSubview(horizontalStack)


            for _ in 0..<columns {
                let tokenView = UIView()
                tokenView.backgroundColor = UIColor(named: C.colors.gray2)
                tokenView.layer.cornerRadius = 10
                tokenView.clipsToBounds = true
                
                let tokenImage = UIImageView()
                tokenImage.image = UIImage(named: "camera")
                tokenView.addSubview(tokenImage)
                tokenImage.translatesAutoresizingMaskIntoConstraints = false
                let size = view.frame.width / 6
                NSLayoutConstraint.activate([
                    tokenImage.centerXAnchor.constraint(equalTo: tokenView.centerXAnchor),
                    tokenImage.centerYAnchor.constraint(equalTo: tokenView.centerYAnchor),
                    tokenImage.heightAnchor.constraint(equalToConstant: size),
                    tokenImage.widthAnchor.constraint(equalToConstant: size)
                ])

                horizontalStack.addArrangedSubview(tokenView)
                tokenViews.append(tokenView)
            }

        }
        
        for (index, tokenView) in tokenViews.enumerated() {
            tokenView.isUserInteractionEnabled = true
            tokenView.tag = index

            let tap = UITapGestureRecognizer(target: self, action: #selector(tokenTapped(_:)))
            tokenView.addGestureRecognizer(tap)
        }



        
        
    }
    
}
