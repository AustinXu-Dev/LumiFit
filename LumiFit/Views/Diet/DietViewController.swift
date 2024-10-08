//
//  DietViewController.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/23.
//

import UIKit
import Alamofire

struct Item {
    var date: String
    var calories: Int
}

class DietViewController: UIViewController {
    
    //MARK: - PROPERTIES
    var networkManager: NetworkManager?
    var calorieViewModel = CalorieViewModel.shared
    var waterCalViewModel = WaterCalViewModel.shared
    var intakeViewModel = IntakeViewModel.shared 
    @IBOutlet weak var tableView: UITableView!
    
    private var cells: [(cellId: String, cellHeight: CGFloat)] = [(cellId: "nutrition_cell", cellHeight: 235), (cellId: "water_cell", cellHeight: 210)]
    private var goToMealSegueId = "meal_detail"
    private var goToWaterSegueId = "water_detail"
    var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        checkAndPromptForGoalSetting(viewModel: waterCalViewModel)
        
        // Set up IntakeViewModel delegate to observe changes
        intakeViewModel.delegate = self
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        self.navigationItem.rightBarButtonItem = shareButton
        
    }
    
    @objc func shareButtonTapped() {
        // Create an action sheet for the user to choose between exporting water or calorie intake
        let actionSheet = UIAlertController(title: "Export Data", message: "Choose what you would like to export:", preferredStyle: .actionSheet)
        
        // Export Water Intake Option
        let exportWaterAction = UIAlertAction(title: "Export Water Intake", style: .default) { _ in
            self.exportWaterIntake()
        }
        
        // Export Calorie Intake Option
        let exportCalorieAction = UIAlertAction(title: "Export Calorie Intake", style: .default) { _ in
            self.exportCalorieIntake()
        }
        
        // Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add actions to the action sheet
        actionSheet.addAction(exportWaterAction)
        actionSheet.addAction(exportCalorieAction)
        actionSheet.addAction(cancelAction)
        
        // Present the action sheet
        self.present(actionSheet, animated: true, completion: nil)
    }

    func exportWaterIntake() {
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        let waterHistory = intakeViewModel.getWaterIntakeHistory(startDate: startDate, endDate: endDate)
        
        // Convert the water intake data to CSV or any exportable format
        var csvText = "Date,Total Water Intake\n"
        for item in waterHistory {
            let date = DateFormatter.localizedString(from: item.date, dateStyle: .short, timeStyle: .none)
            let newLine = "\(date),\(item.totalIntake) ml\n"
            csvText.append(newLine)
        }
        
        // Create a temporary file for the CSV data
        let fileName = "WaterIntake.csv"
        let path = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try csvText.write(to: path, atomically: true, encoding: .utf8)
            shareFile(path: path)
        } catch {
            print("Failed to create file: \(error)")
        }
    }
    
    func exportCalorieIntake() {
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        let calorieHistory = intakeViewModel.getCalorieIntakeHistory(startDate: startDate, endDate: endDate)
        
        // Convert the calorie intake data to CSV or any exportable format
        var csvText = "Date,Total Calorie Intake\n"
        for item in calorieHistory {
            let date = DateFormatter.localizedString(from: item.date, dateStyle: .short, timeStyle: .none)
            let newLine = "\(date),\(item.totalCalories) kcal\n"
            csvText.append(newLine)
        }
        
        // Create a temporary file for the CSV data
        let fileName = "CalorieIntake.csv"
        let path = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try csvText.write(to: path, atomically: true, encoding: .utf8)
            shareFile(path: path)
        } catch {
            print("Failed to create file: \(error)")
        }
    }

    func shareFile(path: URL) {
        let activityViewController = UIActivityViewController(activityItems: [path], applicationActivities: nil)
        
        // Exclude certain activities if needed
        activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact]
        
        // Present the activity view controller to share the file
        self.present(activityViewController, animated: true, completion: nil)
    }


    
    // MARK: - Validation for goal setting
    func checkAndPromptForGoalSetting(viewModel: WaterCalViewModel) {
        if UserDefaults.standard.double(forKey: "waterGoal") == 0 {
            showGoalSettingAlert(for: viewModel)
        }
    }

    func showGoalSettingAlert(for viewModel: WaterCalViewModel) {
        let alert = UIAlertController(title: "Set Your Water Goal", message: "Please set your daily water intake goal.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter water goal in ml"
            textField.keyboardType = .numberPad
        }
        
        let setAction = UIAlertAction(title: "Set Goal", style: .default) { _ in
            if let goalText = alert.textFields?.first?.text, let goal = Double(goalText) {
                viewModel.setGoal(goal)
                self.tableView.reloadData()
            }
        }
        
        // If user cancel, set the default goal to 2500
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            viewModel.setGoal(2500)
            self.tableView.reloadData()
        }
        
        alert.addAction(setAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case goToMealSegueId:
            if let destinationVC = segue.destination as? NutritionDetailViewController {
                destinationVC.calorieViewModel = calorieViewModel
            }
        case goToWaterSegueId:
            if let destinationVC = segue.destination as? WaterDetailViewController {
                destinationVC.waterCalViewModel = waterCalViewModel
            }
        case .none:
            break
        case .some(_):
            break
        }
    }
    
    @IBAction func unwindToDietViewController(segue: UIStoryboardSegue) {
        // Update the NutritionTableViewCell UI after adding calories or water
        tableView.reloadData()
        print(calorieViewModel.currentCalories, "for debug")
        // Ensure the intake data is added to the database
        intakeViewModel.addCalorieIntake(amount: calorieViewModel.currentCalories)
    }
    
    @IBAction func unwindToDietViewControllerFromWater(segue: UIStoryboardSegue){
        tableView.reloadData()
        print(waterCalViewModel.currentWaterAmount)
        intakeViewModel.addWaterIntake(amount: waterCalViewModel.currentWaterAmount)
    }
}

// MARK: - UITableView Delegate
extension DietViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        return cells[index].cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        if index % 2 == 0 {
            //MARK: - Nutrition Intake Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: cells[index].cellId, for: indexPath) as! NutritionTableViewCell
            cell.delegate = self
            cell.configure(with: calorieViewModel) // Passing calorie view model
            return cell
        } else {
            //MARK: - Water Intake Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: cells[index].cellId, for: indexPath) as! WaterTableViewCell
            cell.delegate = self
            cell.configure(with: waterCalViewModel)
            return cell
        }
    }
}

// MARK: - Nutrition Cell Delegate, Water Cell Delegate
extension DietViewController: NutritionTableViewCellDelegate, WaterTableViewCellDelegate {
    
    func didTapButton(in cell: NutritionTableViewCell) {
        // Perform segue or navigation
        performSegue(withIdentifier: goToMealSegueId, sender: cell)
    }
    
    func didTapButton(in cell: WaterTableViewCell) {
        performSegue(withIdentifier: goToWaterSegueId, sender: cell)
    }
}

// MARK: - IntakeViewModelDelegate
extension DietViewController: IntakeViewModelDelegate {
    
    func didUpdateCalorieIntake() {
        // Handle any UI updates or refreshes specific to the DietViewController
        // if needed, or simply ensure the data is correctly handled.
        tableView.reloadData()
        checkCalGoalAchievement()
        print("Calorie intake updated.")
    }
    
    func didUpdateWaterIntake() {
        // Handle any UI updates or refreshes specific to the DietViewController
        // if needed, or simply ensure the data is correctly handled.
        tableView.reloadData()
        checkWaterGoalAchievement()
        print("Water intake updated.")
    }
    
    func checkCalGoalAchievement() {
        if calorieViewModel.progress >= 1 {
            showGoalAchievedAlert(for: "calorie")
        }
    }
    
    func checkWaterGoalAchievement() {
        if waterCalViewModel.progress >= 1 {
            showGoalAchievedAlert(for: "water")
        }
    }

    
    func showGoalAchievedAlert(for name: String) {
        // Create the alert controller with no message to allow more space
        let alertController = UIAlertController(title: "YAY!", message: nil, preferredStyle: .alert)

        // Create a custom view that holds the image and label
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 150))

        // Image View Setup
        let imageView = UIImageView()
        imageView.image = UIImage(named: "yay") // Replace with your own image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(imageView)

        // Label Setup
        let label = UILabel()
        label.text = "You have achieved your daily \(name) goal!"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(label)

        // Add custom view to the alert controller
        alertController.view.addSubview(customView)

        // Set constraints for imageView
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: customView.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            
            // Label constraints
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            label.leftAnchor.constraint(equalTo: customView.leftAnchor, constant: 10),
            label.rightAnchor.constraint(equalTo: customView.rightAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -10)
        ])

        // Create the Done action
        let doneAction = UIAlertAction(title: "Done", style: .default, handler: nil)
        alertController.addAction(doneAction)

        // Set the custom view as the content of the alert controller
        alertController.view.addSubview(customView)

        // Set size of alert controller's content view
        let height = NSLayoutConstraint(item: alertController.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        alertController.view.addConstraint(height)

        // Present the alert
        self.present(alertController, animated: true, completion: nil)
    }

}

