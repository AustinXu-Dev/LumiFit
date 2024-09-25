//
//  HealthKitManager.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/9/16.
//

import Foundation
import HealthKit

class HealthKitManager {
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()
    
    let allTypes: Set = [
        HKQuantityType.workoutType(),
        HKQuantityType(.stepCount),
        HKQuantityType(.heartRate),
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.distanceCycling),
        HKQuantityType(.distanceWalkingRunning),
        
    ]
    
    func requestHealthKitAuthorization() async {
        do {
            // Check that Health data is available on the device.
            if HKHealthStore.isHealthDataAvailable() {
                // Asynchronously request authorization to the data.
                try await healthStore.requestAuthorization(toShare: [], read: allTypes)
            }
        } catch {
            // Handle authorization errors
            print("*** An unexpected error occurred while requesting authorization: \(error.localizedDescription) ***")
        }
    }
}
