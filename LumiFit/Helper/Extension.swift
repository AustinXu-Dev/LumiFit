//
//  Extension.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/9/6.
//

import UIKit
import PhotosUI

extension UIViewController: @retroactive PHPickerViewControllerDelegate {
    
    func configureImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
    }
    
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if let itemProvider = results.first?.itemProvider {
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    if let selectedImage = image as? UIImage {
                        DispatchQueue.main.async {
                            // Replace this with the relevant view controller's image view
                            if let self = self as? EditProfileViewController {
                                self.profileImage.image = selectedImage
                            } else if let self = self as? ProfileViewController {
                                self.profileImage.image = selectedImage
                            }
                            
                            // Save the selected image to the device
                            self?.saveImageToDocumentsDirectory(image: selectedImage)
                        }
                    }
                }
            }
        }
    }
    
    func saveImageToDocumentsDirectory(image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            let fileName = "profileImage.jpg"
            if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = directory.appendingPathComponent(fileName)
                
                do {
                    try data.write(to: fileURL)
                    UserDefaults.standard.set(fileURL.path, forKey: "profileImagePath")
                } catch {
                    print("Error saving image: \(error)")
                }
            }
        }
    }
}
