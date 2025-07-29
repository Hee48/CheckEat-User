//
//  SecretManager.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/20/25.
//

import Foundation

enum SecretManager {
    static func getValue(for key: String) -> String {
        guard let url = Bundle.main.url(forResource: "Secret", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
              let dict = plist as? [String: Any],
              let value = dict[key] as? String else {
            fatalError("🚨 Secret for key \(key) not found. 확인 필요.")
        }
        print("✅ Secret for key : \(key)")
        return value
    }
}
