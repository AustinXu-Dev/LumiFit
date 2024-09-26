//
//  CalorieViewModel.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/29.
//

import Foundation
import UserNotifications

class CalorieViewModel {
    static var shared = CalorieViewModel()
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
        guard dailyGoal != 0 else { return 0 }  // Avoid division by zero
        return totalCalories / dailyGoal
    }
    
    func addCalories(_ calories: Double) {
        totalCalories += calories
        NotificationCenter.default.post(name: .calorieProgressUpdated, object: nil)
        if totalCalories == 0 {
            scheduleCalorieZeroNotification()
        }
    }
    
    func resetCalories() {
        totalCalories = 0
        scheduleCalorieZeroNotification()

    }
    
    private func scheduleCalorieZeroNotification() {
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "No Calories Logged!"
        content.body = "Your current calorie count is zero. Time to add some food!"
        content.sound = UNNotificationSound.default
        
        // Create the trigger (instant)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        // Create the request
        let request = UNNotificationRequest(identifier: "calorieZeroNotification", content: content, trigger: trigger)
        
        // Schedule the notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}
