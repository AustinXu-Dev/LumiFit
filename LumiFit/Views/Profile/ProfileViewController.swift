//
//  ProfileViewController.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/23.
//

import UIKit
import PhotosUI

class ProfileViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editButton: UIImageView!
    
    // MARK: - Properties
    var person: PersonModel?
    var hasShownAlert = false // Flag to prevent showing the alert multiple times
    private var editProfileVcId = "edit_profile"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        configureEditGesture()
        
        // Load saved profile image
        if let imagePath = UserDefaults.standard.string(forKey: "profileImagePath") {
            if let savedImage = loadImageFromDocumentsDirectory(filePath: imagePath) {
                profileImage.image = savedImage
            }
        }
        
        // Load saved data if available
        if let savedPerson = getSavedPersonData() {
            person = savedPerson
            nameLabel.text = person?.name 
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fetch updated data from UserDefaults
        if let updatedPerson = getSavedPersonData() {
            person = updatedPerson
            nameLabel.text = person?.name
            collectionView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Show the alert to input data if no person data is saved and alert hasn't been shown
        if person == nil && !hasShownAlert {
            DispatchQueue.main.async {
                self.showAlertToInputData()
            }
        } else {
            // Reload the collection view if data exists
            nameLabel.text = person?.name
            collectionView.reloadData()
        }
    }
    
    // Helper function to load the image from the documents directory
    func loadImageFromDocumentsDirectory(filePath: String) -> UIImage? {
        let fileURL = URL(fileURLWithPath: filePath)
        do {
            let data = try Data(contentsOf: fileURL)
            return UIImage(data: data)
        } catch {
            print("Error loading image: \(error)")
            return nil
        }
    }
    
    func configureEditGesture(){
        profileView.layer.cornerRadius = profileView.frame.size.width / 2
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        editButton.layer.cornerRadius = editButton.frame.size.width / 2
        editButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        editButton.addGestureRecognizer(tapGesture)
    }

    @objc func pickImage(){
        configureImagePicker()
    }

    // MARK: - Show Alert to Input Data
    func showAlertToInputData() {
        let alertController = UIAlertController(title: "Enter Profile Info", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Name"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Birthday (dd/mm/yyyy)"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Weight (kg)"
            textField.keyboardType = .decimalPad
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Height (cm)"
            textField.keyboardType = .decimalPad
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] (_) in
            guard let name = alertController.textFields?[0].text, !name.isEmpty,
                  let birthDate = alertController.textFields?[1].text, !birthDate.isEmpty,
                  let weightText = alertController.textFields?[2].text, let weight = Double(weightText),
                  let heightText = alertController.textFields?[3].text, let height = Double(heightText) else {
                print("Invalid input")
                return
            }
            
            // Initialize the person object
            let person = PersonModel(name: name, birthDate: birthDate, weight: weight, height: height)
            
            // Save data to UserDefaults
            self?.savePersonData(person: person)
            self?.person = person
            
            // Reload collection view with new data
            self?.collectionView.reloadData()
        }
        
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: {
            self.hasShownAlert = true // Set flag to true after presenting the alert
        })
    }

    // MARK: - Save and Get Data from UserDefaults
    func savePersonData(person: PersonModel) {
        UserDefaults.standard.set(person.name, forKey: "name")
        UserDefaults.standard.set(person.birthDate, forKey: "birthDate")
        UserDefaults.standard.set(person.weight, forKey: "weight")
        UserDefaults.standard.set(person.height, forKey: "height")
    }
    
    func getSavedPersonData() -> PersonModel? {
        guard let name = UserDefaults.standard.string(forKey: "name"),
              let birthDate = UserDefaults.standard.string(forKey: "birthDate") else { return nil }
        
        let weight = UserDefaults.standard.double(forKey: "weight")
        let height = UserDefaults.standard.double(forKey: "height")
        
        return PersonModel(name: name, birthDate: birthDate, weight: weight, height: height)
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Always dequeue a cell first
        if indexPath.row < 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "person_detail", for: indexPath) as! PersonDetailCell
            
            if let person = person {
                // Set the person data in the cell
                switch indexPath.row {
                case 0:
                    cell.label.text = "\(person.birthDate)"
                    cell.imageView.image = UIImage(named: "bdIcon")
                case 1:
                    cell.label.text = "\(person.weight) kg"
                    cell.imageView.image = UIImage(named: "weightIcon")
                case 2:
                    cell.label.text = "\(person.height) cm"
                    cell.imageView.image = UIImage(named: "heightIcon")
                default:
                    break
                }
            } else {
                // Set default values if person is nil
                cell.label.text = "No Data"
                cell.imageView.image = UIImage(systemName: "person.crop.circle")
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "other_setting", for: indexPath) as! EditPersonDetailCell
            
            switch indexPath.row {
            case 3:
                cell.imageView.image = UIImage(systemName: "gearshape.fill")
                cell.label.text = "Edit Profile Info"
                
            case 4:
                cell.imageView.image = UIImage(named: "themeIcon")
                cell.label.text = "Change Theme"
            case 5:
                cell.imageView.image = UIImage(named: "translateIcon")
                cell.label.text = "Change Languages"
            default:
                break
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 3{
            let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: editProfileVcId) as! EditProfileViewController
            destinationVC.person = person
            navigationController?.pushViewController(destinationVC, animated: true)
        }
        if indexPath.row == 4{
            var 
        }
    }

}

