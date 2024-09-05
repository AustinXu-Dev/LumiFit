//
//  WaterDetailViewController.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/30.
//

import UIKit

class WaterDetailViewController: UIViewController {

    @IBOutlet weak var stepperValue: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var waterCalViewModel: WaterCalViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func stepperAction(_ sender: Any) {
        stepperValue.text = "\(Int(stepper.value)) glass(es)"
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        waterCalViewModel?.addWaterAmount(stepper.value)
        self.performSegue(withIdentifier: "unwindToDietFromWater", sender: self)
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
