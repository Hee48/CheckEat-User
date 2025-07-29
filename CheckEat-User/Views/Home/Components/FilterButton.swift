//
//  FilterButton.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/21/25.
//

import SwiftUI

struct FilterButton: View {
    
    @Binding var selectedFilter: String
    @Binding var selectedStoreType: String
    @Binding var searchText: String
    
    let filters = ["마이필터", "할랄", "비건", "락토", "오보", "락토오보", "페스코", "폴로"]
    let storeTypeFilters = ["전체", "음식점", "카페"]
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                if selectedFilter.isEmpty {
                    // 1차 필터
                    ForEach(filters, id: \.self) { filter in
                        Button {
                            if selectedFilter == filter {
                                selectedFilter = ""
                                 selectedStoreType = "전체"
                            } else {
                                selectedFilter = filter
                            }
                        } label: {
                            Text(filter)
                                .selectedButtonStyle(isSelected: selectedFilter == filter)
                        }
                    }
                } else {
                    // 2차 필터
                    ForEach(storeTypeFilters, id: \.self) { type in
                        Button {
                            if selectedStoreType == type {
                                selectedStoreType = "전체"
                            } else {
                                selectedStoreType = type
                            }
                        } label: {
                            Text(type)
                                .selectedButtonStyle(isSelected: selectedStoreType == type)
                        }
                    }
                    Button {
                        selectedFilter = ""
                        selectedStoreType = "전체"
                        searchText = ""
                    } label: {
                        Text("돌아가기")
                            .selectedButtonStyle(isSelected: false)
                    }
                }
            }
        }
    }
}
