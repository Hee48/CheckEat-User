//
//  SectionView.swift
//  CheckEat-Business
//
//  Created by 최준영 on 7/14/25.
//

import SwiftUI

struct SectionView: View {
    let title: String
    let buttons: [(title: String, destination: SettingDestination)]
    var onButtonTap: (SettingDestination) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .semibold14()
                .foregroundStyle(.buttonOP20)
            
            ForEach(buttons, id: \.title) { button in
                Button(action: {
                    onButtonTap(button.destination)
                }) {
                    Text(button.title)
                        .medium16()
                        .foregroundStyle(.buttonAuth)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
                }
            }
        }
    }
}


