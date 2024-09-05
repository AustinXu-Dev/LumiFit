//
//  WaterCalViewModel.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/31.
//

import Foundation

class WaterCalViewModel {
    
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
            return UserDefaults.standard.double(forKey: "waterGoal") != 0 ? UserDefaults.standard.double(forKey: "waterGoal") : 3700
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
    }
    
    func setGoal(_ goal: Double) {
        dailyGoal = goal
    }
}
