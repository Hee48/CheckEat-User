//
//  SearchBar.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/21/25.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var searchText: String
    var placeholder: String = ""
    var onSearch: () -> Void
    
    var body: some View {
        HStack {
            TextField(
                LocalizedStringKey(placeholder),
                text: $searchText,
                onCommit: {
                    onSearch()
                }
            )
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .regular14()
            
            Button(action: {
                onSearch()
            }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.buttonAuth)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
        .background(.buttonOP)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.buttonOP20, lineWidth: 1)
        )
    }
}

struct LocalizedSearchBar: View {
    
    @Binding var searchText: String
    var placeholder: String = ""
    var onSearch: () -> Void
    
    @State private var currentLanguage = LanguageSettingsViewModel.getCurrentLanguage()
    
    var body: some View {
        HStack {
            TextField(
                placeholder,
                text: $searchText,
                onCommit: {
                    onSearch()
                }
            )
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .regular14()
            
            Button(action: {
                onSearch()
            }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.buttonAuth)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
        .background(.buttonOP)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.buttonOP20, lineWidth: 1)
        )
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LanguageChanged"))) { _ in
            currentLanguage = LanguageSettingsViewModel.getCurrentLanguage()
        }
        .id(currentLanguage)
    }
}
