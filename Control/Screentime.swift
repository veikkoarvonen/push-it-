//
//  ViewController.swift
//  Push It!
//
//  Created by Veikko Arvonen on 18.1.2026.
//

import UIKit

class ScreentimeVC: UIViewController {
    
    var hasSetUI: Bool = false
    let builder = UIBuilder()
    var uiElements = ScreentimeUIElements()
    var timer: Timer?
   
//MARK: VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !hasSetUI else { return }
        hasSetUI = true
        setUI()
        reloadSliderValues()
        initializeTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Screentime view will appear")
        initializeTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Screentime view will disappear")
        terminateTimer()
    }
    
//MARK: - Objc functions
    
    @objc private func handleAppTap() {
        print("Choosing apps to block")
    }
    
    @objc private func pushUpSliderValueChanged(_ sender: UISlider) {
        let roundedValue = Int(sender.value.rounded())
        sender.value = Float(roundedValue) // snap slider to whole numbers
        uiElements.pushUpLabel.text = "\(roundedValue)"
        UserDefaults.standard.set(roundedValue, forKey: C.userDefaultValues.pushUps)
    }
    
    @objc private func minuteSliderValueChanged(_ sender: UISlider) {
        let roundedValue = Int(sender.value.rounded())
        sender.value = Float(roundedValue) // snap slider to whole numbers
        uiElements.minuteLabel.text = "\(roundedValue)"
        UserDefaults.standard.set(roundedValue, forKey: C.userDefaultValues.minutes)
    }
    
    private func reloadSliderValues() {
        
        guard hasSetUI else { return }
        
        if let savedPushUpsValue = UserDefaults.standard.value(forKey: C.userDefaultValues.pushUps) as? Int {
            uiElements.pushUpSlider.value = Float(savedPushUpsValue)
            uiElements.pushUpLabel.text = "\(savedPushUpsValue)"
        } else {
            print("No push ups saved in user defaults, setting default value")
            uiElements.pushUpSlider.value = 20
            uiElements.pushUpLabel.text = "20"
            UserDefaults.standard.set(20, forKey: C.userDefaultValues.pushUps)
        }
        
        if let savedMinutesValue = UserDefaults.standard.value(forKey: C.userDefaultValues.minutes) as? Int {
            uiElements.minuteSlider.value = Float(savedMinutesValue)
            uiElements.minuteLabel.text = "\(savedMinutesValue)"
        } else {
            print("No minutes saved in user defaults, setting default value")
            uiElements.minuteSlider.value = 20
            uiElements.minuteLabel.text = "20"
            UserDefaults.standard.set(20, forKey: C.userDefaultValues.minutes)
        }
        
        
        
    }
    
//MARK: - Timer logic
    
    private func terminateTimer() {
        guard timer != nil else { return }
        print("Terminating timer")
        timer!.invalidate()
        timer = nil
    }
    
    private func initializeTimer() {
        guard timer == nil && hasSetUI else { return }
        print("Initializing timer")
        timer?.invalidate()
        
        updateScreentimeLabel()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateScreentimeLabel()
            print("Timer fired")
        }
    }
    
    private func updateScreentimeLabel() {
        let screentimeEndMoment = UserDefaults.standard.value(forKey: C.userDefaultValues.screentimeEnd) as? Date ?? Date()
        let now = Date()
        
        let remainingSeconds = max(0, Int(screentimeEndMoment.timeIntervalSince(now)))
        uiElements.remainingScreenTimeLabel.text = format(seconds: remainingSeconds)
        
        if remainingSeconds <= 0 {
            terminateTimer()
        }
    }
    
    private func format(seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60

        if h > 0 {
            return String(format: "%d:%02d:%02d", h, m, s)
        } else {
            return String(format: "%02d:%02d", m, s)
        }
    }

    
   

}



//MARK: - UI builder

extension ScreentimeVC {
    
   
    
    private func setUI() {
        setContainerViews(containerFrame: view.frame, safeArea: view.safeAreaInsets)
        setHeaderViewlElements()
        setSubheader()
        setReamainingScreentimeContainer()
        setBlockAppsLabel()
        setPushUpCountElements()
        setMinuteCountElements()
    }
    
    private func setContainerViews(containerFrame: CGRect, safeArea: UIEdgeInsets) {
        
        let backGroundView = UIView()
        backGroundView.backgroundColor = UIColor(named: C.colors.gray1)
        backGroundView.frame = CGRect(x: 0.0, y: safeArea.top, width: containerFrame.width, height: containerFrame.height - safeArea.top - safeArea.bottom)
        view.addSubview(backGroundView)
        uiElements.backGroundView = backGroundView
        
        let headerView = UIView()
        headerView.backgroundColor = C.testUIwithBackgroundColor ? .red : .clear
        headerView.frame = CGRect(x: 0.0, y: 0.0, width: containerFrame.width, height: 80.0)
        uiElements.headerView = headerView
            uiElements.backGroundView.addSubview(headerView)
        
        let subheaderView = UIView()
        subheaderView.backgroundColor = C.testUIwithBackgroundColor ? .orange : .clear
        subheaderView.frame = CGRect(x: 0.0, y: uiElements.headerView.frame.maxY, width: containerFrame.width, height: 60.0)
            uiElements.backGroundView.addSubview(subheaderView)
        uiElements.subHeaderView = subheaderView
        
        let remainingScreentimeContainer = UIView()
        remainingScreentimeContainer.backgroundColor = C.testUIwithBackgroundColor ? .yellow : .clear
        remainingScreentimeContainer.frame = CGRect(x: 0.0, y: uiElements.subHeaderView.frame.maxY, width: containerFrame.width, height: containerFrame.width * (3 / 5))
        uiElements.backGroundView.addSubview(remainingScreentimeContainer)
        uiElements.remainingScreentimeContainer = remainingScreentimeContainer
        
        let appBlockContainer = UIView()
        appBlockContainer.backgroundColor = C.testUIwithBackgroundColor ? .green : .clear
        appBlockContainer.frame = CGRect(x: 0.0, y: uiElements.remainingScreentimeContainer.frame.maxY, width: containerFrame.width, height: 50.0)
        uiElements.backGroundView.addSubview(appBlockContainer)
        uiElements.blockAppsButtonView = appBlockContainer
        
        let remainingYSpace: CGFloat = uiElements.backGroundView.frame.height - uiElements.blockAppsButtonView.frame.maxY
        
        let pushUpCountContainer = UIView()
        pushUpCountContainer.backgroundColor = C.testUIwithBackgroundColor ? .orange : .clear
        pushUpCountContainer.frame = CGRect(x: 0.0, y: uiElements.blockAppsButtonView.frame.maxY, width: containerFrame.width, height: remainingYSpace / 2)
        uiElements.backGroundView.addSubview(pushUpCountContainer)
        uiElements.pushUpCountContainer = pushUpCountContainer
        
        let minuteCountContainer = UIView()
        minuteCountContainer.backgroundColor = C.testUIwithBackgroundColor ? .red : .clear
        minuteCountContainer.frame = CGRect(x: 0.0, y: uiElements.pushUpCountContainer.frame.maxY, width: containerFrame.width, height: remainingYSpace / 2)
        uiElements.backGroundView.addSubview(minuteCountContainer)
        uiElements.minuteCountContainer = minuteCountContainer
        
        
      
        
    }
    private func setHeaderViewlElements() {
        
        let headerHeigth: CGFloat = 40.0
        let decorationHeigth: CGFloat = 20.0
        let decorationOffset: CGFloat = 10.0
        let margin: CGFloat = 30.0
        
        let decorationView = UIView()
        decorationView.backgroundColor = UIColor(named: C.colors.orange1)
        decorationView.frame = CGRect(x: margin, y: margin + headerHeigth - decorationOffset, width: 200.0, height: decorationHeigth)
        uiElements.headerView.addSubview(decorationView)
        
        let header = UILabel()
        builder.styleHeader(header: header, text: "Screentime")
        header.frame = CGRect(x: margin, y: margin, width: 300.0, height: headerHeigth)
        header.backgroundColor = C.testUIwithBackgroundColor ? .blue.withAlphaComponent(0.4) : .clear
        uiElements.headerView.addSubview(header)
        
    }
    private func setSubheader() {
        
        let subheader = UILabel()
        subheader.numberOfLines = 0
        builder.styleLabel(header: subheader, text: "Adjust the amount of push ups to unlock screen time", fontSize: 15.0, textColor: .white, alignment: .left)
        let containerHeight: CGFloat = uiElements.subHeaderView.frame.height
        let marginX: CGFloat = 30.0
        subheader.backgroundColor = C.testUIwithBackgroundColor ? .green.withAlphaComponent(0.8) : .clear
        subheader.frame = CGRect(x: marginX, y: 0.0, width: uiElements.headerView.frame.width - marginX * 2 - 100.0, height: containerHeight)
        uiElements.subHeaderView.addSubview(subheader)
        
    }
    private func setReamainingScreentimeContainer() {
        
        let parentContainerHeigth: CGFloat = uiElements.remainingScreentimeContainer.frame.height
        let marginX: CGFloat = 30.0
        let marginY: CGFloat = 10.0
        
        let container = UIView()
        container.backgroundColor = UIColor(named: C.colors.gray2)
        container.layer.cornerRadius = 15.0
        let containerWidth: CGFloat = uiElements.remainingScreentimeContainer.frame.width - marginX * 2
        let containerHeigth: CGFloat = parentContainerHeigth - marginY * 2
        container.frame = CGRect(x: marginX, y: marginY, width: containerWidth, height: containerHeigth)
        
        
        let remainingLabel = UILabel()
        builder.styleLabel(header: remainingLabel, text: "59 min", fontSize: 35.0, textColor: .white, alignment: .center)
        remainingLabel.textAlignment = .center
        remainingLabel.backgroundColor = C.testUIwithBackgroundColor ? .red : .clear
        remainingLabel.frame = CGRect(x: 0.0, y: containerHeigth / 2.0 - 25.0, width: container.frame.width, height: 50.0)
        container.addSubview(remainingLabel)
        uiElements.remainingScreenTimeLabel = remainingLabel
        
        
        let labelHeigth: CGFloat = 30.0
        let paddingY: CGFloat = 20.0
        
        
        let upperLabel = UILabel()
        builder.styleLabel(header: upperLabel, text: "You have...", fontSize: 25.0, textColor: .white, alignment: .center)
        upperLabel.textAlignment = .center
        upperLabel.backgroundColor = C.testUIwithBackgroundColor ? .red : .clear
        upperLabel.frame = CGRect(x: 0.0, y: paddingY, width: containerWidth, height: labelHeigth)
        container.addSubview(upperLabel)
        
        let lowerLabel = UILabel()
        builder.styleLabel(header: lowerLabel, text: "...of screentime remaining", fontSize: 20.0, textColor: .white, alignment: .center)
        lowerLabel.textAlignment = .center
        lowerLabel.backgroundColor = C.testUIwithBackgroundColor ? .red : .clear
        lowerLabel.frame = CGRect(x: 0.0, y: containerHeigth - paddingY - labelHeigth, width: containerWidth, height: labelHeigth)
        container.addSubview(lowerLabel)
        
        
        uiElements.remainingScreentimeContainer.addSubview(container)
        
        
    }
    private func setBlockAppsLabel() {
        let label = UILabel()
        builder.styleLabel(header: label, text: "Choose the Apps to Control", fontSize: 18.0, textColor: .white, alignment: .center)
        label.textAlignment = .center
        label.backgroundColor = C.testUIwithBackgroundColor ? .blue.withAlphaComponent(0.5) : .clear
        let marginX: CGFloat = 30.0
        let marginY: CGFloat = 5.0
        let containerFrame = uiElements.blockAppsButtonView.frame
        label.frame = CGRect(x: marginX, y: marginY, width: containerFrame.width - marginX * 2, height: containerFrame.height - marginY * 2)
        
        
        let appTap = UITapGestureRecognizer(target: self, action: #selector(handleAppTap))
        label.addGestureRecognizer(appTap)
        label.isUserInteractionEnabled = true
        
        uiElements.blockAppsButtonView.addSubview(label)
        uiElements.blockAppsLabel = label
    }
    private func setPushUpCountElements() {
        
        let marginX: CGFloat = 30.0
        let sliderHeigth: CGFloat = 40.0
        let labelHeight: CGFloat = 25.0
        let containerFrame = uiElements.pushUpCountContainer.frame
        
        let pushUpSlider = UISlider()
        pushUpSlider.backgroundColor = C.testUIwithBackgroundColor ? .blue.withAlphaComponent(0.5) : .clear
        pushUpSlider.tintColor = .white
        pushUpSlider.minimumValue = 5.0
        pushUpSlider.maximumValue = 50.0
        pushUpSlider.frame = CGRect(x: marginX, y: containerFrame.height / 2 - sliderHeigth / 2, width: containerFrame.width - marginX * 2, height: sliderHeigth)
        pushUpSlider.addTarget(self, action: #selector(pushUpSliderValueChanged(_:)), for: .valueChanged
        )

        uiElements.pushUpCountContainer.addSubview(pushUpSlider)
        uiElements.pushUpSlider = pushUpSlider
        
        let upperLabel = UILabel()
        builder.styleLabel(header: upperLabel, text: "50", fontSize: 20.0, textColor: .white, alignment: .center)
        upperLabel.textAlignment = .center
        upperLabel.backgroundColor = C.testUIwithBackgroundColor ? .red : .clear
        upperLabel.frame = CGRect(x: marginX, y: pushUpSlider.frame.minY - labelHeight, width: containerFrame.width - marginX * 2, height: labelHeight)
        uiElements.pushUpCountContainer.addSubview(upperLabel)
        uiElements.pushUpLabel = upperLabel
        
        let lowerLabel = UILabel()
        builder.styleLabel(header: lowerLabel, text: "push ups give you", fontSize: 20.0, textColor: .white, alignment: .center)
        lowerLabel.textAlignment = .center
        lowerLabel.backgroundColor = C.testUIwithBackgroundColor ? .red : .clear
        lowerLabel.frame = CGRect(x: marginX, y: pushUpSlider.frame.maxY, width: containerFrame.width - marginX * 2, height: labelHeight)
        uiElements.pushUpCountContainer.addSubview(lowerLabel)
        
    }
    private func setMinuteCountElements() {
        
        let marginX: CGFloat = 30.0
        let sliderHeigth: CGFloat = 40.0
        let labelHeight: CGFloat = 25.0
        let containerFrame = uiElements.minuteCountContainer.frame
        
        let minuteSlider = UISlider()
        minuteSlider.backgroundColor = C.testUIwithBackgroundColor ? .blue.withAlphaComponent(0.5) : .clear
        minuteSlider.frame = CGRect(x: marginX, y: containerFrame.height / 2 - sliderHeigth / 2, width: containerFrame.width - marginX * 2, height: sliderHeigth)
        minuteSlider.tintColor = .white
        minuteSlider.minimumValue = 5.0
        minuteSlider.maximumValue = 50.0
        minuteSlider.addTarget(self, action: #selector(minuteSliderValueChanged(_:)), for: .valueChanged
        )
        uiElements.minuteCountContainer.addSubview(minuteSlider)
        uiElements.minuteSlider = minuteSlider
        
        let upperLabel = UILabel()
        builder.styleLabel(header: upperLabel, text: "50", fontSize: 20.0, textColor: .white, alignment: .center)
        upperLabel.textAlignment = .center
        upperLabel.backgroundColor = C.testUIwithBackgroundColor ? .red : .clear
        upperLabel.frame = CGRect(x: marginX, y: minuteSlider.frame.minY - labelHeight, width: containerFrame.width - marginX * 2, height: labelHeight)
        uiElements.minuteCountContainer.addSubview(upperLabel)
        uiElements.minuteLabel = upperLabel
        
        let lowerLabel = UILabel()
        builder.styleLabel(header: lowerLabel, text: "minutes of screentime", fontSize: 20.0, textColor: .white, alignment: .center)
        lowerLabel.textAlignment = .center
        lowerLabel.backgroundColor = C.testUIwithBackgroundColor ? .red : .clear
        lowerLabel.frame = CGRect(x: marginX, y: minuteSlider.frame.maxY, width: containerFrame.width - marginX * 2, height: labelHeight)
        uiElements.minuteCountContainer.addSubview(lowerLabel)
        
    }
    
}

struct ScreentimeUIElements {
    
    var backGroundView: UIView!
    var headerView: UIView!
    var subHeaderView: UIView!
    var remainingScreentimeContainer: UIView!
    var remainingScreenTimeLabel: UILabel!
    var blockAppsButtonView: UIView!
    var blockAppsLabel: UILabel!
    var pushUpCountContainer: UIView!
    var pushUpSlider: UISlider!
    var pushUpLabel: UILabel!
    var minuteCountContainer: UIView!
    var minuteSlider: UISlider!
    var minuteLabel: UILabel!
}

