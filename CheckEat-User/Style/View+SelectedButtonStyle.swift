//
//  View+SelectedButtonStyle.swift
//  CheckEat-Business
//
//  Created by 최준영 on 7/17/25.
//

import SwiftUI

struct SelectedButtonStyle: ViewModifier {
    var isSelected: Bool
    var width: CGFloat? = nil

    func body(content: Content) -> some View {
        content
            .regular12()
            .frame(minWidth: width)
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background(isSelected ? Color.buttonSoft : Color.background)
            .foregroundStyle(isSelected ? Color.primary : Color.buttonOP50)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.buttonEnable : Color.buttonOP20, lineWidth: 1)
            }
    }
}

extension View {
    func selectedButtonStyle(isSelected: Bool, width: CGFloat? = nil) -> some View {
        self.modifier(SelectedButtonStyle(isSelected: isSelected, width: width))
    }
}
