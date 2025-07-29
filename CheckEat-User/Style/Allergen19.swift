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
        Allergen(imageName: "난류", displayName: "난류", id: 1),
        Allergen(imageName: "우유", displayName: "우유", id: 2),
        Allergen(imageName: "메밀", displayName: "메밀", id: 3),
        Allergen(imageName: "땅콩", displayName: "땅콩", id: 4),
        Allergen(imageName: "대두", displayName: "대두", id: 5),
        Allergen(imageName: "밀", displayName: "밀", id: 6),
        Allergen(imageName: "고등어", displayName: "고등어", id: 7),
        Allergen(imageName: "게", displayName: "게", id: 8),
        Allergen(imageName: "새우", displayName: "새우", id: 9),
        Allergen(imageName: "돼지고기", displayName: "돼지고기", id: 10),
        Allergen(imageName: "복숭아", displayName: "복숭아", id: 11),
        Allergen(imageName: "토마토", displayName: "토마토", id: 12),
        Allergen(imageName: "아황산류", displayName: "아황산류", id: 13),
        Allergen(imageName: "호두", displayName: "호두", id: 14),
        Allergen(imageName: "닭고기", displayName: "닭고기", id: 15),
        Allergen(imageName: "쇠고기", displayName: "쇠고기", id: 16),
        Allergen(imageName: "오징어", displayName: "오징어", id: 17),
        Allergen(imageName: "조개류", displayName: "조개류", id: 18),
        Allergen(imageName: "잣", displayName: "잣", id: 19)
    ]
}

