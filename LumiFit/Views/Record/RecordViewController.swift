//
//  RecordViewController.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/23.
//

import UIKit
import DGCharts

class RecordViewController: UIViewController, IntakeViewModelDelegate {
    
    let intakeViewModel = IntakeViewModel()
    var calorieChartView: BarChartView!
    var waterChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate to self
        intakeViewModel.delegate = self
        
        // Set up the chart views
        setupChartViews()
        
        // Display the calorie and water intake data in the charts
        displayCalorieIntakeChart()
        displayWaterIntakeChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Refresh both charts with the latest data every time the view appears
        displayCalorieIntakeChart()
        displayWaterIntakeChart()
    }
    
    func setupChartViews() {
        // Setup calorie chart view
        calorieChartView = BarChartView()
        calorieChartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calorieChartView)
        
        // Setup water chart view
        waterChartView = BarChartView()
        waterChartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(waterChartView)
        
        // Set up chart view constraints
        NSLayoutConstraint.activate([
            calorieChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            calorieChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            calorieChartView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            calorieChartView.heightAnchor.constraint(equalToConstant: 300),
            
            waterChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            waterChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            waterChartView.topAnchor.constraint(equalTo: calorieChartView.bottomAnchor, constant: 50),
            waterChartView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
//    func displayCalorieIntakeChart() {
//        let startDate = Calendar.current.date(byAdding: .day, value: -90, to: Date())! // Match the 90-day window
//        let endDate = Date()
//        let history = intakeViewModel.getCalorieIntakeHistory(startDate: startDate, endDate: endDate)
//
//        var dataEntries: [BarChartDataEntry] = []
//        
//        for entry in history {
//            let xValue = entry.date.timeIntervalSince1970
//            let yValue = entry.totalCalories
//            let dataEntry = BarChartDataEntry(x: xValue, y: yValue)
//            dataEntries.append(dataEntry)
//        }
//
//        let barDataSet = BarChartDataSet(entries: dataEntries, label: "Calorie Intake (kcal)")
//        barDataSet.colors = [NSUIColor.blue] // Match the blue color in the image
//        barDataSet.barBorderWidth = 0.5 // Slight border to make bars stand out
//        barDataSet.barShadowColor = NSUIColor.gray // Add shadow for a similar effect
//
//        let barData = BarChartData(dataSet: barDataSet)
//        
//        // Bar chart styling for a cleaner look
//        calorieChartView.data = barData
//        calorieChartView.xAxis.labelPosition = .bottom
//        calorieChartView.xAxis.valueFormatter = DateValueFormatter() // Format x-axis as dates
//        calorieChartView.xAxis.drawGridLinesEnabled = false // Clean x-axis appearance
//        calorieChartView.rightAxis.enabled = false // Hide right axis
//        calorieChartView.leftAxis.axisMinimum = 0 // Ensure no negative values
//        calorieChartView.legend.enabled = false // Hide legend for simplicity
//        calorieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
//    }

    func displayCalorieIntakeChart() {
        let dummyData: [BarChartDataEntry] = [
            BarChartDataEntry(x: 1, y: 2000),
            BarChartDataEntry(x: 2, y: 1800),
            BarChartDataEntry(x: 3, y: 2200),
            BarChartDataEntry(x: 4, y: 2500)
        ]

        let barDataSet = BarChartDataSet(entries: dummyData, label: "Calorie Intake (kcal)")
        barDataSet.colors = [NSUIColor.blue]

        let barData = BarChartData(dataSet: barDataSet)
        calorieChartView.data = barData
        calorieChartView.xAxis.labelPosition = .bottom
        calorieChartView.xAxis.drawGridLinesEnabled = false
        calorieChartView.rightAxis.enabled = false
        calorieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }


    func displayWaterIntakeChart() {
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        let history = intakeViewModel.getWaterIntakeHistory(startDate: startDate, endDate: endDate)
        
        var dataEntries: [BarChartDataEntry] = []
        
        for entry in history {
            let xValue = entry.date.timeIntervalSince1970
            let yValue = entry.totalIntake
            print("Water Data: \(entry.date), \(yValue)")  // Debugging: Print out the values
            let dataEntry = BarChartDataEntry(x: xValue, y: yValue)
            dataEntries.append(dataEntry)
        }
        
        let barDataSet = BarChartDataSet(entries: dataEntries, label: "Water Intake (ml)")
        barDataSet.colors = [NSUIColor.blue] // Customize bar color
        
        let barData = BarChartData(dataSet: barDataSet)
        
        waterChartView.data = barData
        waterChartView.xAxis.labelPosition = .bottom
        waterChartView.xAxis.valueFormatter = DateValueFormatter() // Format x-axis as dates
        waterChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }

    
    // MARK: - IntakeViewModelDelegate
    
    func didUpdateCalorieIntake() {
        displayCalorieIntakeChart() // Update the calorie chart when the data changes
    }
    
    func didUpdateWaterIntake() {
        displayWaterIntakeChart() // Update the water chart when the data changes
    }
}

// Custom formatter to display date on x-axis
class DateValueFormatter: AxisValueFormatter {
    private let dateFormatter: DateFormatter
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d" // Customize date format
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        return dateFormatter.string(from: date)
    }
}
