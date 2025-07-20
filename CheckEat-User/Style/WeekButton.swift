//
//  WeekButton.swift
//  CheckEat-Business
//
//  Created by Hee  on 7/15/25.
//

import SwiftUI

struct WeekButton: View {
    let day: String
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(day)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .black)
                .frame(width: 37, height: 48)
                .background(RoundedRectangle(cornerRadius: 5)
                    .fill(isSelected ? Color.black : Color(Color.buttonOP)))
        }
        .buttonStyle(.plain)
    }
}

