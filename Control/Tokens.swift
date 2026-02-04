//
//  Tokens.swift
//  Push It!
//
//  Created by Veikko Arvonen on 19.1.2026.
//

import UIKit
import SceneKit

class TokensVC: UIViewController {
    
    var hasSetUI: Bool = false
    var tokenContainerViews: [UIView] = []
    var sceneContainer: SCNView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
        reloadTokenViews()
        //setScene()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.bool(forKey: C.userDefaultValues.shouldUpdateTokens) {
            reloadTokenViews()
            UserDefaults.standard.set(false, forKey: C.userDefaultValues.shouldUpdateTokens)
        }
        
    }
    
    @objc private func tokenTapped(_ gesture: UITapGestureRecognizer) {
        guard let tappedView = gesture.view else { return }
        let index = tappedView.tag
        print("Token tapped at index:", index)
        
    }
    
    private func reloadTokenViews() {
        guard C.tokenLimits.count == tokenContainerViews.count else { return }
        let totalPushUps = CalendarManager.shared.totalPushUps()
        print("Reloading tokens!")
        for i in 0..<C.tokenLimits.count {
            let hasCompletedToken = totalPushUps >= C.tokenLimits[i]
            tokenContainerViews[i].isUserInteractionEnabled = hasCompletedToken
            tokenContainerViews[i].alpha = hasCompletedToken ? 1 : 0.5
        }
        UserDefaults.standard.set(false, forKey: C.userDefaultValues.shouldUpdateTokens)
    }



}

extension TokensVC {
    
    private func setScene() {
        // 1: Load .obj file
               let scene = SCNScene(named: "doubloon.obj")
               
               // 2: Add camera node
               let cameraNode = SCNNode()
               cameraNode.camera = SCNCamera()
               // 3: Place camera
               cameraNode.position = SCNVector3(x: 0, y: 10, z: 35)
               // 4: Set camera on scene
               scene?.rootNode.addChildNode(cameraNode)
               
               // 5: Adding light to scene
               let lightNode = SCNNode()
               lightNode.light = SCNLight()
               lightNode.light?.type = .omni
               lightNode.position = SCNVector3(x: 0, y: 10, z: 35)
               scene?.rootNode.addChildNode(lightNode)
               
               // 6: Creating and adding ambien light to scene
               let ambientLightNode = SCNNode()
               ambientLightNode.light = SCNLight()
               ambientLightNode.light?.type = .ambient
               ambientLightNode.light?.color = UIColor.darkGray
               scene?.rootNode.addChildNode(ambientLightNode)
               
               // If you don't want to fix manually the lights
       //        sceneView.autoenablesDefaultLighting = true
               
               // Allow user to manipulate camera
        sceneContainer.allowsCameraControl = true
               
               // Show FPS logs and timming
               // sceneView.showsStatistics = true
               
               // Set background color
        sceneContainer.backgroundColor = UIColor.black
               
               // Allow user translate image
        sceneContainer.cameraControlConfiguration.allowsTranslation = false
               
               // Set scene settings
        sceneContainer.scene = scene
    }
    
    private func setUI() {
        
        guard !hasSetUI else { return }
        hasSetUI = true
        
        let builder = UIBuilder()
        
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
        bgView.backgroundColor = .clear
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
        decorationView.backgroundColor = .black
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
                tokenView.backgroundColor = .black
                tokenView.layer.cornerRadius = 10
                tokenView.clipsToBounds = true
                
                let tokenImage = UIImageView()
                tokenImage.image = UIImage(named: "tokensSmall")
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
        
        tokenContainerViews = tokenViews

/*
        let sceneView = SCNView()
        
        bgView.addSubview(sceneView)
        
        sceneContainer = sceneView
        
        sceneView.frame = CGRect(x: 0.0, y: 30.0, width: view.frame.width, height: 500.0)
*/
        
    }
    
}
