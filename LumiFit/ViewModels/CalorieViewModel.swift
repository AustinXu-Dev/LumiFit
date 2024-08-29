//
//  CalorieViewModel.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/29.
//

import Foundation

class CalorieViewModel {
    private var totalCalories: Double = 0
    private let dailyGoal: Double = 2500
    
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
