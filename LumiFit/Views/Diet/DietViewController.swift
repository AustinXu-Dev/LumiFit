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
    @IBOutlet weak var tableView: UITableView!
    
    private var cells: [(cellId: String, cellHeight: CGFloat)] = [(cellId: "nutrition_cell", cellHeight: 235), (cellId: "water_cell", cellHeight: 210)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "meal_detail" {
            if let destinationVC = segue.destination as? NutritionDetailViewController {
                destinationVC.calorieViewModel = calorieViewModel
            }
        }
    }
    @IBAction func unwindToDietViewController(segue: UIStoryboardSegue) {
        if segue.source is NutritionDetailViewController {
            // Update the NutritionTableViewCell UI after adding calories
            tableView.reloadData()
        }
    }
    
}

extension DietViewController: UITableViewDelegate, UITableViewDataSource, NutritionTableViewCellDelegate{
    
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
            return cell
        }
    }
    
    func didTapButton(in cell: NutritionTableViewCell) {
        // Perform segue or navigation
        performSegue(withIdentifier: "meal_detail", sender: cell)
    }
    

    
}
