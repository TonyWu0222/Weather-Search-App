//
//  WeeklyViewController.swift
//  iosApp
//
//  Created by Tony Wu on 11/21/19.
//  Copyright © 2019 Tony Wu. All rights reserved.
//

import UIKit
import Charts

class WeeklyViewController: UIViewController {

    @IBOutlet weak var weeklyCard: UIView!
    @IBOutlet weak var weeklyIcon: UIImageView!
    @IBOutlet weak var weeklySummary: UILabel!
    
    
    @IBOutlet weak var lineChartViewContainer: UIView!
    @IBOutlet weak var lineChartView: LineChartView!
    
    var currentWeather: CurrentWeather? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tabController = tabBarController as! TabBarController
        currentWeather = tabController.currentWeather
        
        //    Top_Card
        weeklyCard.layer.borderColor = UIColor.white.cgColor
        weeklyIcon.image = UIImage(named: (currentWeather?.weeklyIcon)!)
        weeklySummary.text = currentWeather?.weeklySummary
        
        //    Bottom_Figure
        lineChartViewContainer.layer.borderColor = UIColor.white.cgColor
        lineChartView.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.3)
        setChartValues(count: (currentWeather?.temperatureMaxArray)!.count, temperatureMinArray: (currentWeather?.temperatureMinArray)!, temperatureMaxArray: (currentWeather?.temperatureMaxArray)!)
    }
    
    func setChartValues(count: Int, temperatureMinArray: [Int?], temperatureMaxArray: [Int?]) {
        let minValues = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double((currentWeather?.temperatureMinArray[i])!)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let maxValues = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double((currentWeather?.temperatureMaxArray[i])!)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let minValuesSet = LineChartDataSet(entries: minValues, label: "Minimum Temperature (℉)")
        minValuesSet.colors = [NSUIColor.white]
        minValuesSet.circleHoleColor = NSUIColor.white
        minValuesSet.setCircleColor(NSUIColor.white)
        minValuesSet.circleRadius = 5
        let maxValuesSet = LineChartDataSet(entries: maxValues, label: "Maximum Temperature (℉)")
        maxValuesSet.colors = [NSUIColor.orange]
        maxValuesSet.circleHoleColor = NSUIColor.orange
        maxValuesSet.setCircleColor(NSUIColor.orange)
        maxValuesSet.circleRadius = 5
        let data = LineChartData(dataSets: [minValuesSet, maxValuesSet])
        lineChartView.data = data
    }
}
