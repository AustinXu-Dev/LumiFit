//
//  WaterCalViewModel.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/31.
//

import Foundation

class WaterCalViewModel {
    static var shared = WaterCalViewModel()
    
    var glassCount: Double{
        get {
            return UserDefaults.standard.double(forKey: "glassCount")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "glassCount")
        }
    }
    var totalMl: Double {
        return glassCount * 240
    }
    
    var dailyGoal: Double {
        get {
            return UserDefaults.standard.double(forKey: "waterGoal")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "waterGoal")
        }
    }
    
    var currentWaterAmount: Double {
        return totalMl
    }
    
    var progress: Double {
        return totalMl / dailyGoal
    }
    
    func addWaterAmount(_ waterAmount: Double) {
        glassCount += waterAmount
        NotificationCenter.default.post(name: .waterProgressUpdated, object: nil)
    }
    
    func setGoal(_ goal: Double) {
        dailyGoal = goal
        NotificationCenter.default.post(name: .waterProgressUpdated, object: nil)
    }
    
    func resetWaterGoal() {
        dailyGoal = 0 // Reset to default goal (or any desired value)
    }
}
