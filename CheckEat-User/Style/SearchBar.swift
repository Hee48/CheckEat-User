//
//  SearchBar.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/21/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = ""
    var onSearch: () -> Void

    var body: some View {
        HStack {
            TextField(placeholder, text: $text, onCommit: {
                onSearch() // ⌨️ 엔터 시 검색 실행
            })
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .regular14()
            Button(action: {
                onSearch() // 🔍 버튼 클릭 시도 동일하게
            }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.buttonAuth)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
        .background(.buttonOP)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.buttonOP20, lineWidth: 1)
        }
    }
}
