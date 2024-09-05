//
//  EditProfileViewController.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/9/5.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    
    //MARK: - Properties
    var person: PersonModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTextFieldPlaceholder()
    }
    
    func setUpTextFieldPlaceholder() {
        nameTextField.placeholder = person?.name ?? "Enter Name"
        birthDateTextField.placeholder = person?.birthDate ?? "Enter Birth Date (dd/mm/yyyy)"
        
        if let weight = person?.weight {
            weightTextField.placeholder = "\(weight)"
        } else {
            weightTextField.placeholder = "Enter Weight (kg)"
        }
        
        if let height = person?.height {
            heightTextField.placeholder = "\(height)"
        } else {
            heightTextField.placeholder = "Enter Height (cm)"
        }
    }

    
    @IBAction func saveButtonTapped(_ sender: Any) {
        // Retrieve current values from UserDefaults to use them if fields are left blank
        let currentName = UserDefaults.standard.string(forKey: "name") ?? ""
        let currentBirthDate = UserDefaults.standard.string(forKey: "birthDate") ?? ""
        let currentWeight = UserDefaults.standard.double(forKey: "weight")
        let currentHeight = UserDefaults.standard.double(forKey: "height")
        
        // Only update if text fields are not empty, otherwise retain the current values
        let name = !nameTextField.text!.isEmpty ? nameTextField.text! : currentName
        let birthDate = !birthDateTextField.text!.isEmpty ? birthDateTextField.text! : currentBirthDate
        let weight = !weightTextField.text!.isEmpty ? Double(weightTextField.text!)! : currentWeight
        let height = !heightTextField.text!.isEmpty ? Double(heightTextField.text!)! : currentHeight
        
        // Save the data to UserDefaults
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(birthDate, forKey: "birthDate")
        UserDefaults.standard.set(weight, forKey: "weight")
        UserDefaults.standard.set(height, forKey: "height")
        
        print("Profile saved successfully")
        
        navigationController?.popViewController(animated: true)
    }

}
