//
//  DateExtension.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/9/1.
//

import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}
