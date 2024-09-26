//
//  AppDelegate.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/19.
//

import UIKit
import RealmSwift
import HealthKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    let healthKitManager = HealthKitManager.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let config = Realm.Configuration(
            schemaVersion: 2, // Increment this number each time you change the schema
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    // Perform migration logic here
                    
                    migration.enumerateObjects(ofType: WaterIntake.className()) { oldObject, newObject in
                        // Map old dateTimestamp to new id and date
                        if let oldDate = oldObject?["dateTimestamp"] as? Int {
                            newObject?["id"] = UUID()
                            newObject?["date"] = Date(timeIntervalSince1970: TimeInterval(oldDate))
                        }
                    }
                    
                    migration.enumerateObjects(ofType: CalorieIntake.className()) { oldObject, newObject in
                        // Map old dateTimestamp to new id and date
                        if let oldDate = oldObject?["dateTimestamp"] as? Int {
                            newObject?["id"] = UUID()
                            newObject?["date"] = Date(timeIntervalSince1970: TimeInterval(oldDate))
                        }
                    }
                }
            }
        )
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, open the Realm file again
        _ = try! Realm()
        Task {
            await healthKitManager.requestHealthKitAuthorization()
        }
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error.localizedDescription)")
            }
        }
                
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound]) // Show notification when the app is in the foreground
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

