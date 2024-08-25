//
//  DietViewController.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/23.
//

import UIKit
import Alamofire

class DietViewController: UIViewController {

    @IBOutlet weak var foodTextField: UITextField!
    @IBOutlet weak var waterTextField: UITextField!
    
    @IBOutlet weak var calorieLabel: UILabel!
    
    var networkManager: NetworkManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            do {
                // Initialize NetworkManager once
                let manager = try await NetworkManager()
                self.networkManager = manager
            } catch {
                print("Failed to initialize NetworkManager: \(error)")
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func confirmButton(_ sender: UIButton) {
        if let food = foodTextField.text, !food.isEmpty {
            networkManager?.fetchData(params: food) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    if let foodModel = data.items.first {
                        // Update the foodLabel with the result
                        self.calorieLabel.text = "\(foodModel.name): \(foodModel.calories) calories"
                    } else {
                        self.calorieLabel.text = "No food found"
                    }
                case .failure(let error):
                    self.calorieLabel.text = "Error: \(error.localizedDescription)"
                }
            }
        } else {
            calorieLabel.text = "Please enter a food item"
        }
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
