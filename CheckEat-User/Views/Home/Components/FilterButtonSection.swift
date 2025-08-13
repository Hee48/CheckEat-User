//
//  FilterButtonSection.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/10/25.
//

import SwiftUI

struct FilterButtonSection: View {
    
    @Binding var selectedFilter: String
    @Binding var searchText: String
    
    let hasToken: Bool // 토큰 존재 여부
    
    let onFilterSelected: (String) -> Void
    let onFilterClear: () -> Void
    
    // 비건 단계 필터만 표시 (비회원)
    let filters = ["비건", "락토", "오보", "락토오보", "페스코", "폴로"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                // 마이필터는 토큰이 있을 때만 표시 (회원)
                if hasToken {
                    Button {
                        if selectedFilter == "마이필터" {
                            selectedFilter = ""
                            onFilterClear()
                        } else {
                            selectedFilter = "마이필터"
                        }
                    } label: {
                        Text("마이필터")
                            .selectedButtonStyle(isSelected: selectedFilter == "마이필터")
                    }
                }
                
                // 비건 단계 필터들
                ForEach(filters, id: \.self) { filter in
                    Button {
                        if selectedFilter == filter {
                            selectedFilter = ""
                            onFilterClear()
                        } else {
                            selectedFilter = filter
                            onFilterSelected(filter)
                        }
                    } label: {
                        Text(filter)
                            .selectedButtonStyle(isSelected: selectedFilter == filter)
                    }
                }
            }
        }
    }
}
