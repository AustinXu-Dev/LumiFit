//
//  IntakeViewModel.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/9/2.
//

import Foundation
import RealmSwift

protocol IntakeViewModelDelegate: AnyObject {
    func didUpdateCalorieIntake()
    func didUpdateWaterIntake()
}

class IntakeViewModel {
    
    weak var delegate: IntakeViewModelDelegate?
    
    // MARK: - Calorie Intake Methods
    
    func addCalorieIntake(amount: Double) {
        let realm = try! Realm()
        let today = Date().startOfDay
        
        // Assuming that the input is in calories and needs to be converted to kilocalories
        let kcalAmount = amount / 1000
        
        if let existingEntry = realm.objects(CalorieIntake.self).filter("date == %@", today).first {
            // Update the existing entry for today
            try! realm.write {
                print("Existing entry before update:", existingEntry.totalCalories)
                existingEntry.totalCalories = kcalAmount
                print("Existing entry after update:", existingEntry.totalCalories)
            }
        } else {
            // Create a new entry for today
            let newEntry = CalorieIntake(date: today, totalCalories: kcalAmount)
            print("New entry created with calories:", newEntry.totalCalories)
            try! realm.write {
                realm.add(newEntry)
            }
        }
        
        delegate?.didUpdateCalorieIntake() // Notify the delegate about the update
    }



    func resetTodayCalorieIntake() {
        let realm = try! Realm()
        let today = Date().startOfDay
        
        if let entry = realm.objects(CalorieIntake.self).filter("date == %@", today).first {
            // Reset the calorie intake for today
            try! realm.write {
                entry.totalCalories = 0.0
            }
        }
        
        delegate?.didUpdateCalorieIntake() // Notify the delegate about the reset
    }

    func getCalorieIntakeHistory(startDate: Date, endDate: Date) -> Results<CalorieIntake> {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "date BETWEEN {%@, %@}", startDate.startOfDay as CVarArg, endDate.startOfDay as CVarArg)
        return realm.objects(CalorieIntake.self).filter(predicate).sorted(byKeyPath: "date", ascending: true)
    }
    
    // MARK: - Water Intake Methods
    
    func addWaterIntake(amount: Double) {
        let realm = try! Realm()
        let today = Date().startOfDay
        
        if let existingEntry = realm.objects(WaterIntake.self).filter("date == %@", today).first {
            // Update the existing entry for today
            try! realm.write {
                existingEntry.totalIntake = amount
            }
        } else {
            // Create a new entry for today
            let newEntry = WaterIntake(date: today, totalIntake: amount)
            try! realm.write {
                realm.add(newEntry)
            }
        }
        
        delegate?.didUpdateWaterIntake() // Notify the delegate about the update
    }


    func resetTodayWaterIntake() {
        let realm = try! Realm()
        let today = Date().startOfDay
        
        if let entry = realm.objects(WaterIntake.self).filter("date == %@", today).first {
            // Reset the water intake for today
            try! realm.write {
                entry.totalIntake = 0.0
            }
        }
        
        delegate?.didUpdateWaterIntake() // Notify the delegate about the reset
    }

    func getWaterIntakeHistory(startDate: Date, endDate: Date) -> Results<WaterIntake> {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "date BETWEEN {%@, %@}", startDate.startOfDay as CVarArg, endDate.startOfDay as CVarArg)
        return realm.objects(WaterIntake.self).filter(predicate).sorted(byKeyPath: "date", ascending: true)
    }
}
