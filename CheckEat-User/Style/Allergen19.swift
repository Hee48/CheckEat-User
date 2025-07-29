//
//  Allergen19.swift
//  CheckEat-User
//
//  Created by Hee  on 7/29/25.
//

import Foundation


struct Allergen: Identifiable {
    let imageName: String
    let displayName: String
    let id: Int
}

struct AllergenData {
    static let defaultList: [Allergen] = [
        Allergen(imageName: "Egg", displayName: "난류", id: 1),
        Allergen(imageName: "Milk", displayName: "우유", id: 2),
        Allergen(imageName: "Buckwheat", displayName: "메밀", id: 3),
        Allergen(imageName: "Peanut", displayName: "땅콩", id: 4),
        Allergen(imageName: "Soy", displayName: "대두", id: 5),
        Allergen(imageName: "Wheat", displayName: "밀", id: 6),
        Allergen(imageName: "Mackerel", displayName: "고등어", id: 7),
        Allergen(imageName: "Crab", displayName: "게", id: 8),
        Allergen(imageName: "Shrimp", displayName: "새우", id: 9),
        Allergen(imageName: "Pork", displayName: "돼지고기", id: 10),
        Allergen(imageName: "Peach", displayName: "복숭아", id: 11),
        Allergen(imageName: "Tomato", displayName: "토마토", id: 12),
        Allergen(imageName: "Sulfites", displayName: "아황산류", id: 13),
        Allergen(imageName: "Walnut", displayName: "호두", id: 14),
        Allergen(imageName: "Chicken", displayName: "닭고기", id: 15),
        Allergen(imageName: "Beef", displayName: "쇠고기", id: 16),
        Allergen(imageName: "Squid", displayName: "오징어", id: 17),
        Allergen(imageName: "Shellfish", displayName: "조개류", id: 18),
        Allergen(imageName: "PineNut", displayName: "잣", id: 19)
    ]
}

