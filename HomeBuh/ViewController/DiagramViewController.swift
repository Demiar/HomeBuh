//
//  DiagramViewController.swift
//  HomeBuh
//
//  Created by Алексей on 12.09.2021.
//

import UIKit
import Charts

class DiagramViewController: UIViewController {
    let diagram = PieChartView(frame: CGRect(x: 50, y: 100, width: 300, height: 300))
    let data = DataManager.shared.fetchData()
    
    //let players = ["Ozil", "Ramsey", "Laca", "Auba", "Xhaka", "Torreira"]
    //let goals = [6, 8, 26, 30, 8, 10]
    var dictionary: Dictionary<String, Double> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for dat in data {
            guard let title = dat.category?.title else { return }
            if dictionary[title] == nil {
                dictionary[title] = 0.0
            }
                dictionary[title]! += dat.price
        }
        customizeChart(dataPoints: Array(dictionary.keys), values: dictionary.values.map{ Double($0) })
        view.addSubview(diagram)
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {

        // 1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .decimal
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        // 4. Assign it to the chart’s data
        diagram.data = pieChartData
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for _ in 0..<numbersOfColor {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        return colors
    }
}
