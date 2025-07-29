//
//  View+ButtonStyle.swift
//  CheckEat-Business
//
//  Created by 최준영 on 7/7/25.
//

import SwiftUI

extension View {
    // 기본적으로 활성 상태 제공, 필요할 경우엔 비활성 | 활성으로 제공
    func primaryButtonStyle(isEnabled: Bool? = nil) -> some View {
        let enabled = isEnabled ?? true
        return self
            .frame(maxWidth: .infinity)
            .padding()
            .background(enabled ? Color.buttonEnable : Color.buttonDisable)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
    
    func subButtonStyle(isEnabled: Bool? = nil) -> some View {
        return self
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.primary)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.buttonOP50, lineWidth: 1)
            )
    }
}
