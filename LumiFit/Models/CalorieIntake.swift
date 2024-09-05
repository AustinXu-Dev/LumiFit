//
//  CalorieIntake.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/9/1.
//

import Foundation
import RealmSwift

class CalorieIntake: Object {
    @Persisted(primaryKey: true) var id: UUID = UUID()
    @Persisted var date: Date = Date()
    @Persisted var totalCalories: Double = 0.0 // in kilocalories
    
    convenience init(date: Date, totalCalories: Double) {
        self.init()
        self.date = date
        self.totalCalories = totalCalories
    }
}
