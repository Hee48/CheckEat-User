//
//  String+Localized.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/19/25.
//

import Foundation

extension String {
    var localized: String {
        // 현재 앱에서 설정한 언어 사용
        let currentLanguage = LanguageSettingsViewModel.getCurrentLanguage()
        
        if let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        }
        
        // 기본 번들 사용 (fallback)
        return NSLocalizedString(self, comment: "")
    }
}
