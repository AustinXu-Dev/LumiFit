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
    var calorieChartView: LineChartView!
    var waterChartView: LineChartView!
    
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
        calorieChartView = LineChartView()
        calorieChartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calorieChartView)
        
        // Setup water chart view
        waterChartView = LineChartView()
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
    
    func displayCalorieIntakeChart() {
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        let history = intakeViewModel.getCalorieIntakeHistory(startDate: startDate, endDate: endDate)
        
        var dataEntries: [ChartDataEntry] = []
        
        for entry in history {
            let xValue = entry.date.timeIntervalSince1970
            let yValue = entry.totalCalories
            print("Calorie Data: \(entry.date), \(yValue)")  // Debugging: Print out the values
            let dataEntry = ChartDataEntry(x: xValue, y: yValue)
            dataEntries.append(dataEntry)
        }
        
        let lineDataSet = LineChartDataSet(entries: dataEntries, label: "Calorie Intake (kcal)")
        lineDataSet.colors = [NSUIColor.red] // Customize line color
        lineDataSet.circleColors = [NSUIColor.red] // Customize circle color
        lineDataSet.circleRadius = 4.0 // Customize circle radius
        
        let lineData = LineChartData(dataSet: lineDataSet)
        
        calorieChartView.data = lineData
        calorieChartView.xAxis.labelPosition = .bottom
        calorieChartView.xAxis.valueFormatter = DateValueFormatter() // Format x-axis as dates
        calorieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }

    
    func displayWaterIntakeChart() {
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        let history = intakeViewModel.getWaterIntakeHistory(startDate: startDate, endDate: endDate)
        
        var dataEntries: [ChartDataEntry] = []
        
        for entry in history {
            let xValue = entry.date.timeIntervalSince1970
            let yValue = entry.totalIntake
            print("Water Data: \(entry.date), \(yValue)")  // Debugging: Print out the values
            let dataEntry = ChartDataEntry(x: xValue, y: yValue)
            dataEntries.append(dataEntry)
        }
        
        let lineDataSet = LineChartDataSet(entries: dataEntries, label: "Water Intake (ml)")
        lineDataSet.colors = [NSUIColor.blue] // Customize line color
        lineDataSet.circleColors = [NSUIColor.blue] // Customize circle color
        lineDataSet.circleRadius = 4.0 // Customize circle radius
        
        let lineData = LineChartData(dataSet: lineDataSet)
        
        waterChartView.data = lineData
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
