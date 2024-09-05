//
//  CalorieViewModel.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/29.
//

import Foundation

class CalorieViewModel {
    private var totalCalories: Double {
        get {
            return UserDefaults.standard.double(forKey: "totalCalories")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "totalCalories")
        }
    }
    
    private var dailyGoal: Double {
        get {
            return UserDefaults.standard.double(forKey: "calorieGoal") != 0 ? UserDefaults.standard.double(forKey: "calorieGoal") : 2500
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "calorieGoal")
        }
    }
        
    var currentCalories: Double {
        return totalCalories
    }
    
    var progress: Double {
        let progressValue = Double(totalCalories) / Double(dailyGoal)
        return Double(String(format: "%.2f", progressValue)) ?? 0.0
    }
    
    func addCalories(_ calories: Double) {
        totalCalories += calories
    }
}
