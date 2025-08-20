//
//  MyPageChangePasswordCompleteModalView.swift
//  CheckEat-Business
//
//  Created by 최준영 on 7/14/25.
//

import SwiftUI

struct MyPageChangePasswordCompleteModalView: View {
    
    @Environment(\.dismiss) private var dismiss
    var dismissParent: () -> Void  
    var body: some View {
        VStack(spacing: 8) {
            Image("CheckMark")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundStyle(.green)
                .padding(.bottom)
            Group {
                Text("password_change_complete_title1".localized)
                Text("password_change_complete_title2".localized)
            }
            .bold20()
            
            Text("password_change_complete_message".localized)
                .padding(.vertical, 8)
            
            Button {
                dismissParent()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        dismiss()
                    }
            } label: {
                Text("common_close".localized)
                    .subButtonStyle()
                    .semibold16()
                    .padding(.top, 24)
            }
        }
        .padding(.horizontal)
        .padding(.top, 50)
    }
}

//#Preview {
//    MyPageChangePasswordCompleteModalView()
//}
