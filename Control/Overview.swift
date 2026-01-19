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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tabBarController?.tabBar.tintColor = .white
        tabBarController?.tabBar.unselectedItemTintColor = .white.withAlphaComponent(0.6)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !hasSetUI else { return }
        setUI()
        
    }


}

//MARK: - UI Builder
extension OverviewVC {
    
    private func setUI() {
        
        let margin: CGFloat = 30.0
        
        setBackgroundView(containerFrame: view.frame, safeArea: view.safeAreaInsets)
        setHeader(containerFrame: uiElements.backGroundView.frame, margin: margin)
        setSubheaderView(containerFrame: uiElements.backGroundView.frame, margin: margin)
        setPushUpChartView(containerFrame: uiElements.backGroundView.frame, margin: margin)
        setFooterView(containerFrame: uiElements.backGroundView.frame, margin: margin)
        
    }
    
    private func setBackgroundView(containerFrame: CGRect, safeArea: UIEdgeInsets) {
        let backGroundView = UIView()
        backGroundView.backgroundColor = UIColor(named: C.colors.gray1)
        backGroundView.frame = CGRect(x: 0.0, y: safeArea.top, width: containerFrame.width, height: containerFrame.height - safeArea.top - safeArea.bottom)
        view.addSubview(backGroundView)
        uiElements.backGroundView = backGroundView
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
        decorationView.backgroundColor = UIColor(named: C.colors.orange1)
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
        
        //Lines
        
        var yOffset: CGFloat = 0.0
        let yInterval: CGFloat = chartContainer.frame.height / 5.0
        
        for _ in 0..<5 {
            let lineView = UIView()
            lineView.backgroundColor = C.testUIwithBackgroundColor ? .green : UIColor(named: C.colors.gray2)
            lineView.frame = CGRect(x: 0.0, y: yOffset, width: chartContainer.frame.width, height: 1.0)
            chartContainer.addSubview(lineView)
            yOffset += yInterval
        }
        
        //Columns
        
        let columnWidth: CGFloat = chartContainer.frame.width / 7.0 - 2.0
        var xOffset: CGFloat = 1.0
        
        var columns: [UIView] = []
        
        for _ in 0..<7 {
            let columnView = UIView()
            columnView.backgroundColor = .white
            columnView.frame = CGRect(x: xOffset, y: 0.0, width: columnWidth, height: chartContainer.frame.height)
            chartContainer.addSubview(columnView)
            xOffset += columnWidth + 2.0
            columnView.layer.cornerRadius = 8.0
            columns.append(columnView)
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
        footerView.backgroundColor = UIColor(named: C.colors.gray2)
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
    var pushUpColumns: [UIView]!
    
    var footerView: UIView!
    var footerCounter: UILabel!
    var footerTextLabel: UILabel!
    var footerPercentageCounter: UILabel!
    
    
}
