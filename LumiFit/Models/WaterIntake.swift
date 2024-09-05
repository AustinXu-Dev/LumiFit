//
//  WaterIntake.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/9/1.
//

import Foundation
import RealmSwift

class WaterIntake: Object {
    @Persisted(primaryKey: true) var id: UUID = UUID()
    @Persisted var date: Date = Date()
    @Persisted var totalIntake: Double = 0.0 // in milliliters
    
    convenience init(date: Date, totalIntake: Double) {
        self.init()
        self.date = date
        self.totalIntake = totalIntake
    }
}
