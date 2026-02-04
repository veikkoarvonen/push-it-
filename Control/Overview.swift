//
//  Overview.swift
//  Push It!
//
//  Created by Veikko Arvonen on 18.1.2026.
//

import UIKit

class OverviewVC: UIViewController {
    
    var hasSetUI: Bool = false
    let builder = UIBuilder()
    var uiElements = OverviewUIElements()
    let coreData = CoreDataManager()
    let calManager = CalendarManager()

//MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //calManager.resetScreentime()
        //coreData.createWorkout(reps: Int16(16), date: Date())
        //coreData.deleteAllWorkouts()
        //print(calManager.pushUpsForWeek(weekOffset: 0))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !hasSetUI else { return }
        hasSetUI = true
        setUI()
        updateUIColumns(useTestData: false, animated: true)
        updateLabels(useTestData: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.bool(forKey: C.userDefaultValues.shouldUpdateSheet) {
            updateUIColumns(useTestData: false, animated: true)
            updateLabels(useTestData: false)
            UserDefaults.standard.set(false, forKey: C.userDefaultValues.shouldUpdateSheet)
            print("Push ups have changed, updating UI columns.")
        } else {
            print("View did appear but no need to update UI columns.")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        uiElements.pushUpDisplayView.isHidden = true
    }
    
//MARK: - Objc funcs
    
    @objc private func columnTapped(_ gesture: UITapGestureRecognizer) {
        guard let columnView = gesture.view else { return }

        let index = columnView.tag
        //print("Column tapped at index:", index)
        
        uiElements.pushUpDisplayView.isHidden = false
        uiElements.pushUpDisplayView.center.x = columnView.center.x
        uiElements.pushUpDisplayView.frame.origin.y = columnView.frame.minY - 20.0
        
        var upperText: String {
            switch index {
            case 0: return "Mon"
            case 1: return "Tue"
            case 2: return "Wed"
            case 3: return "Thu"
            case 4: return "Fri"
            case 5: return "Sat"
            default: return "Sun"
            }
        }
        uiElements.pushUpDisplayViewLabel1.text = upperText
        
        var dateComps = Calendar.current.dateComponents([.year, .weekOfYear, .weekday], from: Date())
        
        var dayCompIndex: Int {
            switch index {
            case 0: return 2 //Mon
            case 1: return 3 //Tue
            case 2: return 4 //Wed
            case 3: return 5 //Thu
            case 4: return 6 //Fri
            case 5: return 7 //Sat
            case 6: return 1 //Sun
            default: return 1
            }
        }
        
        dateComps.weekday = dayCompIndex
        guard let targetDate = Calendar.current.date(from: dateComps) else { return }
        let targetDayWorkouts = coreData.fetchSingleDayWorkouts(for: targetDate)
        let pushUpsForTargetDate = targetDayWorkouts.reduce(0) { $0 + $1.reps }
        
        uiElements.pushUpDisplayViewLabel2.text = "\(pushUpsForTargetDate)"
        

    }
    
    @objc private func backgroundTapped() {
        print("Background tapped")
        uiElements.pushUpDisplayView.isHidden = true
        //NotificationManager.shared.scheduleTestNotification(after: 5.0)
    }




}

//MARK: - UI Builder
extension OverviewVC {
    
    private func updateUIColumns(useTestData: Bool, animated: Bool) {
        
        let dataForColumns: [Int] = useTestData ? C.testDataForThisWeek : calManager.pushUpsForWeek(weekOffset: 0).singleDates
        
        guard dataForColumns.count == 7 else { return }
        guard uiElements.pushUpColumns.count == 7 else { return }
        
        print(dataForColumns)
        
        let highestValue: Int = dataForColumns.max() ?? 50
        var maxSheetValue: Int {
            var maxValue: Int = 10
            while maxValue < highestValue {
                maxValue += 10
            }
            return maxValue
        }
        
        print("Highest value in array: \(highestValue), setting sheet max value to: \(maxSheetValue)")
        
        
        for i in 0..<7 {
            
            if dataForColumns[i] == 0 {
                print("Push up data for day \(i) is 0, not adding corresponding column")
                uiElements.pushUpColumns[i].isHidden = true
                continue
            }
            
            let sheetHeigth = uiElements.pushUpColumnsContainer.frame.height
            let relativeHeigthForColumn = CGFloat(dataForColumns[i]) / CGFloat(maxSheetValue)
            let newHeight: CGFloat = sheetHeigth * relativeHeigthForColumn
            
            let yOffset: CGFloat = sheetHeigth - newHeight
            
            uiElements.pushUpColumns[i].isHidden = false
            uiElements.pushUpColumns[i].frame.size.height = animated ? 0 : newHeight
            uiElements.pushUpColumns[i].frame.origin.y = animated ? sheetHeigth : yOffset
            
            if animated {
                UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut]) { [self] in
                    uiElements.pushUpColumns[i].frame.origin.y = yOffset
                    uiElements.pushUpColumns[i].frame.size.height = newHeight
                }
            }
            
        }
        
     
        
    }
    
    private func updateLabels(useTestData: Bool) {
        let totalPushUpsForThisWeek = useTestData ? C.testDataForThisWeek.reduce(0, +) : calManager.pushUpsForWeek(weekOffset: 0).total
        uiElements.subheaderCounter1.text = "\(totalPushUpsForThisWeek)"
        
        let totalPushUpsForLastWeek = useTestData ? C.testDataForPreviousWeek.reduce(0, +) : calManager.pushUpsForWeek(weekOffset: -1).total
        
        let totalPushUps = calManager.totalPushUps()
        uiElements.subheaderCounter2.text = "\(totalPushUps)"
        
        
        let avgPushUpsLastWeek = Double(totalPushUpsForLastWeek) / 7.0
        let avgPushUpsLastWeekRounded = Int(avgPushUpsLastWeek.rounded())
        
        let avgPushUps = Double(totalPushUpsForThisWeek) / 7.0
        let avgPushUpsRounded = Int(avgPushUps.rounded())
        uiElements.footerCounter.text = "\(avgPushUpsRounded)"
        
        //Calculate total percentage difference
        if totalPushUpsForLastWeek != 0 && totalPushUpsForLastWeek != 0 {
            uiElements.subheaderCounter3.isHidden = false
            let diff = totalPushUpsForThisWeek - totalPushUpsForLastWeek
            let p = (Double(diff) / Double(totalPushUpsForLastWeek)) * 100.0
            let rp = Int(p.rounded())
            
            if diff > 0 {
                uiElements.subheaderCounter3.textColor = .green
                uiElements.subheaderCounter3.text = "+\(rp)%"
            } else {
                uiElements.subheaderCounter3.textColor = .red
                uiElements.subheaderCounter3.text = "\(rp)%"
            }
        } else {
            uiElements.subheaderCounter3.isHidden = true
        }
        
        //Calculate avg difference
        if avgPushUpsLastWeek != 0 && avgPushUps != 0 {
            uiElements.footerPercentageCounter.isHidden = false
            let diff = avgPushUpsRounded - avgPushUpsLastWeekRounded
            let p = (Double(diff) / Double(avgPushUpsLastWeekRounded)) * 100.0
            let rp = Int(p.rounded())

            if diff > 0 {
                uiElements.footerPercentageCounter.textColor = .green
                uiElements.footerPercentageCounter.text = "+\(rp)%"
            } else {
                uiElements.footerPercentageCounter.textColor = .red
                uiElements.footerPercentageCounter.text = "\(rp)%"
            }
        } else {
            uiElements.footerPercentageCounter.isHidden = true
        }
        
        /*
        print("Total push ups for this week: \(totalPushUpsForThisWeek)")
        print("Average push ups for this week: \(avgPushUps), rounded: \(avgPushUpsRounded)")
        print("Total push ups for last week: \(totalPushUpsForLastWeek)")
        print("Average push ups for last week: \(avgPushUpsLastWeek), rounded: \(avgPushUpsLastWeekRounded)")
        */
        
    }
    
    private func setUI() {
        
        let margin: CGFloat = 30.0
        
        tabBarController?.tabBar.tintColor = .white
        tabBarController?.tabBar.unselectedItemTintColor = .white.withAlphaComponent(0.6)
        tabBarController?.tabBar.barTintColor = .white
        tabBarController?.tabBar.isTranslucent = true
        
        setBackgroundView(containerFrame: view.frame, safeArea: view.safeAreaInsets)
        setHeader(containerFrame: uiElements.backGroundView.frame, margin: margin)
        setSubheaderView(containerFrame: uiElements.backGroundView.frame, margin: margin)
        setPushUpChartView(containerFrame: uiElements.backGroundView.frame, margin: margin)
        setFooterView(containerFrame: uiElements.backGroundView.frame, margin: margin)
        setPushUpWeekdayContainer()
        
    }
    
    private func setBackgroundView(containerFrame: CGRect, safeArea: UIEdgeInsets) {
        
        let bgView = UIImageView()
        bgView.image = UIImage(named: C.bgView)
        bgView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(bgView)
        
        let backGroundView = UIView()
        backGroundView.backgroundColor = .clear
        backGroundView.frame = CGRect(x: 0.0, y: safeArea.top, width: containerFrame.width, height: containerFrame.height - safeArea.top - safeArea.bottom)
        view.addSubview(backGroundView)
        uiElements.backGroundView = backGroundView
        
        let backgroundTap = UITapGestureRecognizer(
            target: self,
            action: #selector(backgroundTapped)
        )
        backgroundTap.cancelsTouchesInView = false // 👈 important
        backGroundView.addGestureRecognizer(backgroundTap)

        
    }
    private func setHeader(containerFrame: CGRect, margin: CGFloat) {
        
        let headerHeigth: CGFloat = 40.0
        let decorationHeigth: CGFloat = 20.0
        let decorationOffset: CGFloat = 10.0
        
        let containerHeight: CGFloat = headerHeigth + decorationHeigth - decorationOffset + margin
        
        let headerView = UIView()
        headerView.backgroundColor = C.testUIwithBackgroundColor ? .green : .clear
        headerView.frame = CGRect(x: 0.0, y: 0.0, width: containerFrame.width, height: containerHeight)
        uiElements.backGroundView.addSubview(headerView)
        
        let decorationView = UIView()
        decorationView.backgroundColor = .black
        decorationView.frame = CGRect(x: margin, y: margin + headerHeigth - decorationOffset, width: 200.0, height: decorationHeigth)
        headerView.addSubview(decorationView)
        
        let header = UILabel()
        builder.styleHeader(header: header, text: "Overview")
        header.frame = CGRect(x: margin, y: margin, width: 200.0, height: headerHeigth)
        header.backgroundColor = C.testUIwithBackgroundColor ? .red.withAlphaComponent(0.4) : .clear
        headerView.addSubview(header)
        
        uiElements.headerView = headerView
    }
    private func setSubheaderView(containerFrame: CGRect, margin: CGFloat) {
        
        let yMargin: CGFloat = 15.0
        let subheaderHeight: CGFloat = 25.0
        let containerHeigth: CGFloat = subheaderHeight * 2 + yMargin * 2
        let subheaderWidth: CGFloat = 100.0
        let counterWidth: CGFloat = 50.0
        
        //Container
        let subHeaderView = UIView()
        subHeaderView.backgroundColor = C.testUIwithBackgroundColor ? .yellow : .clear
        subHeaderView.frame = CGRect(x: 0.0, y: uiElements.headerView.frame.maxY, width: containerFrame.width, height: containerHeigth)
        uiElements.backGroundView.addSubview(subHeaderView)
        
        
        let subheader1 = UILabel()
        builder.styleSubheader(header: subheader1, text: "This week")
        subheader1.frame = CGRect(x: margin, y: yMargin, width: subheaderWidth, height: subheaderHeight)
        subHeaderView.addSubview(subheader1)
        uiElements.subheader1 = subheader1
        
        let subheader2 = UILabel()
        builder.styleSubheader(header: subheader2, text: "Total")
        subheader2.frame = CGRect(x: margin, y: subheader1.frame.maxY, width: subheaderWidth, height: subheaderHeight)
        subHeaderView.addSubview(subheader2)
        uiElements.subheader2 = subheader2
        
        let counter1 = UILabel()
        builder.styleSubheader(header: counter1, text: "364")
        counter1.frame = CGRect(x: margin + subheaderWidth, y: yMargin, width: counterWidth, height: subheaderHeight)
        subHeaderView.addSubview(counter1)
        uiElements.subheaderCounter1 = counter1
        
        let counter2 = UILabel()
        builder.styleSubheader(header: counter2, text: "1000")
        counter2.frame = CGRect(x: margin + subheaderWidth, y: subheader1.frame.maxY, width: counterWidth, height: subheaderHeight)
        subHeaderView.addSubview(counter2)
        uiElements.subheaderCounter2 = counter2
        
        let counter3 = UILabel()
        builder.styleSubheader(header: counter3, text: "+12%")
        counter3.frame = CGRect(x: margin + subheaderWidth + counterWidth, y: yMargin, width: counterWidth, height: subheaderHeight)
        counter3.textColor = .green
        subHeaderView.addSubview(counter3)
        uiElements.subheaderCounter3 = counter3
        
        
        uiElements.subHeaderView = subHeaderView
        
        
    }
    private func setPushUpChartView(containerFrame: CGRect, margin : CGFloat) {
        
        let marginY: CGFloat = 10.0
        
        let chartView = UIView()
        chartView.backgroundColor = C.testUIwithBackgroundColor ? .red : .clear
        chartView.frame = CGRect(x: 0.0, y: uiElements.subHeaderView.frame.maxY, width: containerFrame.width, height: containerFrame.width * ( 2 / 3))
        uiElements.backGroundView.addSubview(chartView)
        
        let chartContainer = UIView()
        chartContainer.backgroundColor = C.testUIwithBackgroundColor ? .gray : .clear
        chartContainer.frame = CGRect(x: margin, y: marginY, width: chartView.frame.width - margin * 2.0, height: chartView.frame.height - marginY * 2.0)
        chartView.addSubview(chartContainer)
        uiElements.pushUpColumnsContainer = chartContainer
        
        //Lines
        
        var yOffset: CGFloat = 0.0
        let yInterval: CGFloat = chartContainer.frame.height / 5.0
        
        for _ in 0...5 {
            let lineView = UIView()
            lineView.backgroundColor = C.testUIwithBackgroundColor ? .green : .white.withAlphaComponent(0.8)
            lineView.frame = CGRect(x: 0.0, y: yOffset, width: chartContainer.frame.width, height: 1.0)
            chartContainer.addSubview(lineView)
            yOffset += yInterval
        }
        
        //Columns
        
        let columnWidth: CGFloat = chartContainer.frame.width / 7.0 - 2.0
        var xOffset: CGFloat = 1.0
        
        var columns: [UIView] = []
        
        for index in 0..<7 {
            let columnView = UIView()
            columnView.backgroundColor = .white
            columnView.frame = CGRect(
                x: xOffset,
                y: 0.0,
                width: columnWidth,
                height: chartContainer.frame.height
            )
            columnView.layer.cornerRadius = 8.0
            columnView.isUserInteractionEnabled = true

            // Tag identifies the column
            columnView.tag = index

            // Tap gesture
            let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(columnTapped(_:))
            )
            columnView.addGestureRecognizer(tapGesture)

            chartContainer.addSubview(columnView)
            columns.append(columnView)

            xOffset += columnWidth + 2.0
        }

        
        uiElements.pushUpColumns = columns
        
        uiElements.pushUpColumnsView = chartView
        
    }
    private func setFooterView(containerFrame: CGRect, margin: CGFloat) {
        
        let marginY: CGFloat = 20.0
        let padding: CGFloat = 15.0
        let middlePadding: CGFloat = 20.0
        let counterHeigth: CGFloat = 40.0
        let labelHeight: CGFloat = 35.0
        let containerHeigth: CGFloat = padding * 2.0 + middlePadding + counterHeigth + labelHeight
        
        let footerView = UIView()
        footerView.backgroundColor = .black
        footerView.layer.cornerRadius = 15.0
        footerView.frame = CGRect(x: margin, y: uiElements.pushUpColumnsView.frame.maxY + marginY, width: containerFrame.width - margin * 2.0, height: containerHeigth)
        uiElements.backGroundView.addSubview(footerView)
        
        let counter = UILabel()
        builder.styleLabel(header: counter, text: "54", fontSize: 40.0, textColor: .white, alignment: .center)
        counter.textAlignment = .center
        counter.backgroundColor = C.testUIwithBackgroundColor ? .red : .clear
        let counterX: CGFloat = 80.0 + padding
        let counterWidth: CGFloat = footerView.frame.width - counterX * 2.0
        counter.frame = CGRect(x: counterX, y: padding, width: counterWidth, height: counterHeigth)
        footerView.addSubview(counter)
        uiElements.footerCounter = counter
        
        let textLabel = UILabel()
        builder.styleLabel(header: textLabel, text: "Daily Average", fontSize: 30.0, textColor: .white, alignment: .center)
        textLabel.textAlignment = .center
        textLabel.backgroundColor = C.testUIwithBackgroundColor ? .red : .clear
      
        let textlabelY: CGFloat = counter.frame.maxY + middlePadding
        textLabel.frame = CGRect(x: padding, y: textlabelY, width: footerView.frame.width - padding * 2.0, height: labelHeight)
        footerView.addSubview(textLabel)
        uiElements.footerTextLabel = textLabel
        
        let percentageCounter = UILabel()
        builder.styleLabel(header: percentageCounter, text: "+ 12%", fontSize: 15.0, textColor: .green, alignment: .center)
        percentageCounter.textAlignment = .center
        percentageCounter.frame = CGRect(x: padding, y: padding, width: 80.0, height: counterHeigth)
        percentageCounter.backgroundColor = C.testUIwithBackgroundColor ? .black : .clear
        footerView.addSubview(percentageCounter)
        uiElements.footerPercentageCounter = percentageCounter
        
        
        
        uiElements.footerView = footerView
        
    }
    private func setPushUpWeekdayContainer() {
        
        let container = UIView()
        container.backgroundColor = .black
        container.layer.cornerRadius = 10.0
        
        let weekdaylabel = UILabel()
        builder.styleLabel(header: weekdaylabel, text: "Mon", fontSize: 15.0, textColor: .white, alignment: .center)
        weekdaylabel.textAlignment = .center
        weekdaylabel.frame = CGRect(x: 5, y: 5, width: 70, height: 20)
        container.addSubview(weekdaylabel)
        uiElements.pushUpDisplayViewLabel1 = weekdaylabel
        
        let pushUpLabel = UILabel()
        builder.styleLabel(header: pushUpLabel, text: "123", fontSize: 15.0, textColor: .white, alignment: .center)
        pushUpLabel.textAlignment = .center
        pushUpLabel.frame = CGRect(x: 5, y: 25, width: 70, height: 20)
        container.addSubview(pushUpLabel)
        uiElements.pushUpDisplayViewLabel2 = pushUpLabel
        
        container.frame = CGRect(x: 100, y: 100, width: 80, height: 50)
        uiElements.pushUpColumnsContainer.addSubview(container)
        //uiElements.pushUpColumnsContainer.backgroundColor = .red
        uiElements.pushUpDisplayView = container
        uiElements.pushUpDisplayView.isHidden = true
        
    }
    
}

struct OverviewUIElements {
    
    var backGroundView: UIView!
    var headerView: UIView!
    
    var subHeaderView: UIView!
    var subheader1: UILabel!
    var subheader2: UILabel!
    var subheaderCounter1: UILabel!
    var subheaderCounter2: UILabel!
    var subheaderCounter3: UILabel!
    
    var pushUpColumnsView: UIView!
    var pushUpColumnsContainer: UIView!
    var pushUpColumns: [UIView]!
    
    var footerView: UIView!
    var footerCounter: UILabel!
    var footerTextLabel: UILabel!
    var footerPercentageCounter: UILabel!
    
    var pushUpDisplayView: UIView!
    var pushUpDisplayViewLabel1: UILabel!
    var pushUpDisplayViewLabel2: UILabel!
    
    
}
