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
    static let shared = IntakeViewModel()
    weak var delegate: IntakeViewModelDelegate?
    
    // Reference to the shared instances of other view models
    let waterCalViewModel = WaterCalViewModel.shared
    let calorieViewModel = CalorieViewModel.shared

    // MARK: - Calorie Intake Methods

    func addCalorieIntake(amount: Double) {
        let realm = try! Realm()
        let today = Date().startOfDay
        
        let kcalAmount = amount / 1000  // Convert input to kilocalories
        
        if let existingEntry = realm.objects(CalorieIntake.self).filter("date == %@", today).first {
            try! realm.write {
                existingEntry.totalCalories = kcalAmount
            }
        } else {
            let newEntry = CalorieIntake(date: today, totalCalories: kcalAmount)
            try! realm.write {
                realm.add(newEntry)
            }
        }
        
        delegate?.didUpdateCalorieIntake()  // Notify delegate
    }

    func resetTodayCalorieIntake() {
        let realm = try! Realm()
        let today = Date().startOfDay
        
        if let entry = realm.objects(CalorieIntake.self).filter("date == %@", today).first {
            try! realm.write {
                entry.totalCalories = 0.0
            }
        }

        // Reset calorie model
        calorieViewModel.resetCalories()
        
        delegate?.didUpdateCalorieIntake()  // Notify delegate
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
            try! realm.write {
                existingEntry.totalIntake = amount
            }
        } else {
            let newEntry = WaterIntake(date: today, totalIntake: amount)
            try! realm.write {
                realm.add(newEntry)
            }
        }
        
        delegate?.didUpdateWaterIntake()  // Notify delegate
    }

    func resetTodayWaterIntake() {
        let realm = try! Realm()
        let today = Date().startOfDay
        
        if let entry = realm.objects(WaterIntake.self).filter("date == %@", today).first {
            try! realm.write {
                entry.totalIntake = 0.0
            }
        }

        // Reset water model
        waterCalViewModel.glassCount = 0  // Reset the glass count in WaterCalViewModel
        
        delegate?.didUpdateWaterIntake()  // Notify delegate
    }

    func getWaterIntakeHistory(startDate: Date, endDate: Date) -> Results<WaterIntake> {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "date BETWEEN {%@, %@}", startDate.startOfDay as CVarArg, endDate.startOfDay as CVarArg)
        return realm.objects(WaterIntake.self).filter(predicate).sorted(byKeyPath: "date", ascending: true)
    }

    func resetWaterGoal() {
        waterCalViewModel.resetWaterGoal()  // Call reset method from WaterCalViewModel
        delegate?.didUpdateWaterIntake()  // Notify delegate
    }
}
