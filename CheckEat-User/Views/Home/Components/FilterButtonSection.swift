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
    let filters = ["filter_vegan".localized, "filter_lacto".localized, "filter_ovo".localized, "filter_lacto_ovo".localized, "filter_pesco".localized, "filter_pollo".localized]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                // 마이필터는 토큰이 있을 때만 표시 (회원)
                if hasToken {
                    Button {
                        if selectedFilter == "my_filter" {
                            selectedFilter = ""
                            onFilterClear()
                        } else {
                            selectedFilter = "my_filter"
                        }
                    } label: {
                        Text("my_filter") // ✅ SwiftUI가 자동으로 번역
                            .selectedButtonStyle(isSelected: selectedFilter == "my_filter")
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
                        Text(LocalizedStringKey(filter)) // ✅ 명시적으로 번역 처리
                            .selectedButtonStyle(isSelected: selectedFilter == filter)
                    }
                }
            }
        }
    }
}

// 언어 변경에 대응하는 개선된 버전 (선택사항)
struct LocalizedFilterButtonSection: View {
    
    @Binding var selectedFilter: String
    @Binding var searchText: String
    
    let hasToken: Bool
    let onFilterSelected: (String) -> Void
    let onFilterClear: () -> Void
    
    let filters = ["filter_vegan", "filter_lacto", "filter_ovo", "filter_lacto_ovo", "filter_pesco", "filter_pollo"]
    
    // 언어 변경 감지
    @State private var currentLanguage = LanguageSettingsViewModel.getCurrentLanguage()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                // 마이필터
                if hasToken {
                    Button {
                        if selectedFilter == "my_filter" {
                            selectedFilter = ""
                            onFilterClear()
                        } else {
                            selectedFilter = "my_filter"
                        }
                    } label: {
                        Text("my_filter") // SwiftUI 자동 번역
                            .selectedButtonStyle(isSelected: selectedFilter == "my_filter")
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
                        Text(filter) // SwiftUI 자동 번역 (더 간단)
                            .selectedButtonStyle(isSelected: selectedFilter == filter)
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LanguageChanged"))) { _ in
            currentLanguage = LanguageSettingsViewModel.getCurrentLanguage()
        }
        .id(currentLanguage) // 언어 변경시 뷰 재생성
    }
}
