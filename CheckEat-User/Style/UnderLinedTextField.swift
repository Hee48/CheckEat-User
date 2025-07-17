//
//  UnderLinedTextField.swift
//  CheckEat-Business
//
//  Created by Hee  on 7/5/25.
//

import SwiftUI

struct UnderLinedTextField: View {
    let placeholder: String
    var isSecure: Bool = false
    @Binding var text: String
    @FocusState private var isFocused: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 4){
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding(.vertical, 8)
                    .focused($isFocused)
            } else {
                TextField(placeholder, text: $text)
                    .padding(.vertical, 8)
                    .focused($isFocused)
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(isFocused || !text.isEmpty ? .black : Color(red: 0.85, green: 0.85, blue: 0.85))
                .animation(.easeInOut(duration: 0.1), value: isFocused)
        }
    }
}
