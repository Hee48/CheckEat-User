//
//  ChangePasswordCompleteView.swift
//  CheckEat-Business
//
//  Created by 최준영 on 7/5/25.
//

import SwiftUI

struct ChangePasswordCompleteView: View {
    
    @State private var goToLogin: Bool = false
    
    
    var body: some View {
        
        VStack(spacing: 8) {
            Image("CheckMark")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundStyle(.green)
                .padding(.bottom)
            Group {
                Text("비밀번호가")
                Text("성공적으로 변경되었습니다.")
            }
            .bold20()
            
            Button {
                goToLogin = true
            } label: {
                Text("로그인")
                    .primaryButtonStyle()
                    .semibold16()
                    .padding(.vertical, 24)
            }
            .fullScreenCover(isPresented: $goToLogin) {
                LoginView()
            }
        }
        .padding()
        .padding(.bottom, 200)
    }
}

//#Preview {
//    ChangePasswordCompleteView()
//}
