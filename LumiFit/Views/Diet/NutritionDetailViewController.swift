//
//  NutritionDetailViewController.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/29.
//

import UIKit

class NutritionDetailViewController: UIViewController {
    
    //MARK: - PROPERTIES
    var networkManager: NetworkManager?
    
    @IBOutlet weak var foodField: UITextField!
    @IBOutlet weak var calorieLabel: UILabel!
    
    var text = ""
    var calculatedCalories: Double = 0
    var calorieViewModel: CalorieViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize before loading the view
        Task {
            do {
                self.networkManager = try NetworkManager()
            } catch {
                print("Failed to initialize NetworkManager: \(error.localizedDescription)")
            }
        }
    }
    
    
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        if let food = foodField.text, !food.isEmpty {
            self.calorieLabel.text = ""
            calculatedCalories = 0
            networkManager?.fetchData(params: food) { result in
                switch result {
                case .success(let data):
                    if !data.items.isEmpty {
                        data.items.forEach { foodModel in
                            DispatchQueue.main.async {
                                self.calorieLabel.text! += "\(foodModel.name): \(foodModel.calories) calories. "
                            }
                            self.calculatedCalories += foodModel.calories
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.calorieLabel.text = "No food found"
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.calorieLabel.text = "Error: \(error.localizedDescription)"
                    }
                }
            }
        } else {
            calorieLabel.text = "Please enter a food item"
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {

        self.calorieViewModel?.addCalories(Double(self.calculatedCalories))
        self.performSegue(withIdentifier: "unwindToDiet", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
