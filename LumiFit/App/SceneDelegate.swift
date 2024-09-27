//
//  SceneDelegate.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/19.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let intakeViewModel = IntakeViewModel.shared

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        // Retrieve the user preference from UserDefaults
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        
        // Apply the dark or light mode based on user preference
        window?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        checkAndResetDailyIntake()
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        window?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
    }
    
    func checkCalorieAndShowNoti(){
        if intakeViewModel.calorieViewModel.currentCalories == 0{
            scheduleCalorieZeroNotification()
        }
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

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        checkCalorieAndShowNoti()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func checkAndResetDailyIntake() {
        let lastResetDate = UserDefaults.standard.object(forKey: "lastResetDate") as? Date ?? Date.distantPast
        let today = Date().startOfDay
        
        if lastResetDate < today {
            // Reset intake only if the last reset was before today
            intakeViewModel.resetTodayWaterIntake()
            intakeViewModel.resetTodayCalorieIntake()
            intakeViewModel.resetWaterGoal()
            // Update the last reset date to today
            UserDefaults.standard.set(today, forKey: "lastResetDate")
        }
    }

}

