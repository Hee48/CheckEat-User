//
//  Allergen19.swift
//  CheckEat-User
//
//  Created by Hee  on 7/29/25.
//

import Foundation
import SwiftUI

struct Allergen: Identifiable {
    let imageName: String
    let nameKey: String
    let id: Int
    
    var displayName: String {
        NSLocalizedString(nameKey, tableName: nil, bundle: .main, value: "", comment: "")
    }
    var localizedNameKey: LocalizedStringKey { LocalizedStringKey(nameKey) }
}

struct AllergenData {
    static let defaultList: [Allergen] = [
        Allergen(imageName: "Egg",        nameKey: "allergen_egg",        id: 1),
        Allergen(imageName: "Milk",       nameKey: "allergen_milk",       id: 2),
        Allergen(imageName: "Buckwheat",  nameKey: "allergen_buckwheat",  id: 3),
        Allergen(imageName: "Peanut",     nameKey: "allergen_peanut",     id: 4),
        Allergen(imageName: "Soy",        nameKey: "allergen_soy",        id: 5),
        Allergen(imageName: "Wheat",      nameKey: "allergen_wheat",      id: 6),
        Allergen(imageName: "Mackerel",   nameKey: "allergen_mackerel",   id: 7),
        Allergen(imageName: "Crab",       nameKey: "allergen_crab",       id: 8),
        Allergen(imageName: "Shrimp",     nameKey: "allergen_shrimp",     id: 9),
        Allergen(imageName: "Pork",       nameKey: "allergen_pork",       id: 10),
        Allergen(imageName: "Peach",      nameKey: "allergen_peach",      id: 11),
        Allergen(imageName: "Tomato",     nameKey: "allergen_tomato",     id: 12),
        Allergen(imageName: "Sulfites",   nameKey: "allergen_sulfites",   id: 13),
        Allergen(imageName: "Walnut",     nameKey: "allergen_walnut",     id: 14),
        Allergen(imageName: "Chicken",    nameKey: "allergen_chicken",    id: 15),
        Allergen(imageName: "Beef",       nameKey: "allergen_beef",       id: 16),
        Allergen(imageName: "Squid",      nameKey: "allergen_squid",      id: 17),
        Allergen(imageName: "Shellfish",  nameKey: "allergen_shellfish",  id: 18),
        Allergen(imageName: "PineNut",    nameKey: "allergen_pinenut",    id: 19)
    ]
}
