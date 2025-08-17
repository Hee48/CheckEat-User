//
//  VeganType.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/17/25.
//

import Foundation
import SwiftUICore

enum VeganType: Int, CaseIterable {
    case none = 0
    case vegan = 1
    case lacto = 2
    case ovo = 3
    case lactoovo = 4
    case pesco = 5
    case pollo = 6
    
    var displayName: String? {
        switch self {
        case .vegan:    return "비건"
        case .lacto:    return "락토 베지테리언"
        case .ovo:      return "오보 베지테리언"
        case .lactoovo: return "락토 오보 베지테리언"
        case .pesco:    return "페스코 베지테리언"
        case .pollo:    return "폴로 베지테리언"
        case .none:     return nil
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .vegan:    return Color("Vegan")
        case .lacto:    return Color("Lacto")
        case .ovo:      return Color("Ovo")
        case .lactoovo: return Color("Lacto-ovo")
        case .pesco:    return Color("Pesco")
        case .pollo:    return Color("Pollo")
        case .none:     return Color.clear
        }
    }
    
    var textColor: Color {
        switch self {
        case .vegan:
            return Color(red: 0.1686, green: 0.4784, blue: 0.4196)
        case .lacto:
            return Color(red: 0.4784, green: 0.451, blue: 0.1725)
        case .ovo:
            return Color(red: 0.3725, green: 0.2941, blue: 0.5451)
        case .lactoovo:
            return Color(red: 0.2039, green: 0.4941, blue: 0.5804)
        case .pesco:
            return Color(red: 0.2902, green: 0.4353, blue: 0.3529)
        case .pollo:
            return Color(red: 0.7216, green: 0.3569, blue: 0.2941)
        case .none:
            return Color.clear
        }
    }
}
