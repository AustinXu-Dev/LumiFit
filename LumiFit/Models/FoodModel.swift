//
//  FoodModel.swift
//  LumiFit
//
//  Created by Austin Xu on 2024/8/25.
//

import Foundation

struct FoodResponse: Codable {
    let items: [FoodModel]
}

struct FoodModel: Codable {
    let name: String
    let calories: Double
    let servingSizeG: Double
    let fatTotalG: Double
    let fatSaturatedG: Double
    let proteinG: Double
    let sodiumMg: Double
    let potassiumMg: Double
    let cholesterolMg: Double
    let carbohydratesTotalG: Double
    let fiberG: Double
    let sugarG: Double

    enum CodingKeys: String, CodingKey {
        case name
        case calories
        case servingSizeG = "serving_size_g"
        case fatTotalG = "fat_total_g"
        case fatSaturatedG = "fat_saturated_g"
        case proteinG = "protein_g"
        case sodiumMg = "sodium_mg"
        case potassiumMg = "potassium_mg"
        case cholesterolMg = "cholesterol_mg"
        case carbohydratesTotalG = "carbohydrates_total_g"
        case fiberG = "fiber_g"
        case sugarG = "sugar_g"
    }
}

