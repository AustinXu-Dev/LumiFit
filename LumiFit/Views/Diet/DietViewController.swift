//
//  DietViewController.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/23.
//

import UIKit
import Alamofire

class DietViewController: UIViewController {

    var networkManager: NetworkManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        Task{
            do {
                self.networkManager = try await NetworkManager()
            } catch {
                fatalError("Failed to initialize NetworkManager: \(error.localizedDescription)")
            }
        }
        
    }
    
    
//    @IBAction func confirmButton(_ sender: UIButton) {
//        if let food = foodTextField.text, !food.isEmpty {
//            print(food)
//            print("button works")
//            networkManager?.fetchData(params: food) { result in
//                switch result {
//                case .success(let data):
//                    if let foodModel = data.items.first {
//                        // Update the foodLabel with the result
//                        self.calorieLabel.text = "\(foodModel.name): \(foodModel.calories) calories"
//                    } else {
//                        self.calorieLabel.text = "No food found"
//                    }
//                case .failure(let error):
//                    self.calorieLabel.text = "Error: \(error.localizedDescription)"
//                }
//            }
//        } else {
//            calorieLabel.text = "Please enter a food item"
//        }
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DietViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0{
            return 235
        } else{
            return 210
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "nutrition_cell", for: indexPath) as! NutritionTableViewCell
            return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "water_cell", for: indexPath) as! WaterTableViewCell
            return cell
        }
    }
    
    
}
