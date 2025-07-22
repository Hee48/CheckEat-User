//
//  FilterButton.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/21/25.
//

import SwiftUI

struct FilterButton: View {
    
    @Binding var selectedFilter: String
    let filters = ["마이필터", "할랄", "비건", "락토", "오보", "락토오보", "페스코", "폴로"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(filters, id: \.self) { filter in
                    Button(action: {
                        if selectedFilter == filter {
                            selectedFilter = ""
                        } else {
                            selectedFilter = filter
                        }
                    }) {
                        Text(filter)
                            .selectedButtonStyle(isSelected: selectedFilter == filter)
                    }
                }
            }
        }
    }
}
