//
//  DietViewController.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/23.
//

import UIKit
import Alamofire

class DietViewController: UIViewController {
    
    //MARK: - PROPERTIES
    var networkManager: NetworkManager?
    var calorieViewModel = CalorieViewModel()
    var waterCalViewModel = WaterCalViewModel()
    @IBOutlet weak var tableView: UITableView!
    
    private var cells: [(cellId: String, cellHeight: CGFloat)] = [(cellId: "nutrition_cell", cellHeight: 235), (cellId: "water_cell", cellHeight: 210)]
    private var goToMealSegueId = "meal_detail"
    private var goToWaterSegueId = "water_detail"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        checkAndPromptForGoalSetting(viewModel: waterCalViewModel)
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
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(setAction)
        alert.addAction(cancelAction)
        
        // Assume this function is in a UIViewController subclass
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case goToMealSegueId:
            if let destinationVC = segue.destination as? NutritionDetailViewController {
                destinationVC.calorieViewModel = calorieViewModel
            }
        case goToWaterSegueId:
            if let destinationVC = segue.destination as? WaterDetailViewController {
                destinationVC.waterCalViewModel = waterCalViewModel
//                destinationVC.calorieViewModel = calorieViewModel
            }
        case .none:
            break
        case .some(_):
            break
        }
    }
    @IBAction func unwindToDietViewController(segue: UIStoryboardSegue) {
            // Update the NutritionTableViewCell UI after adding calories
        tableView.reloadData()
        print(waterCalViewModel.currentWaterAmount)
        
    }
    
}

// MARK: - UITableView Delegate
extension DietViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        if index % 2 == 0{
            return cells[index].cellHeight
        } else{
            return cells[index].cellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        if index % 2 == 0{
            //MARK: - Nutrition Intake Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: cells[index].cellId, for: indexPath) as! NutritionTableViewCell
            cell.delegate = self
            cell.configure(with: calorieViewModel) //Passing calorie view model
            return cell
        } else{
            //MARK: - Water Intake Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: cells[index].cellId, for: indexPath) as! WaterTableViewCell
            cell.delegate = self
            cell.configure(with: waterCalViewModel)
            return cell
        }
    }
    
}

// MARK: - Nutrition Cell Delegate, Water Cell Delegate
extension DietViewController: NutritionTableViewCellDelegate, WaterTableViewCellDelegate{
    // Handle the add meal button did tap
    func didTapButton(in cell: NutritionTableViewCell) {
        // Perform segue or navigation
        performSegue(withIdentifier: goToMealSegueId, sender: cell)
    }
    
    // Handle the add meal button did tap
    func didTapButton(in cell: WaterTableViewCell) {
        performSegue(withIdentifier: goToWaterSegueId, sender: cell)
    }

}

