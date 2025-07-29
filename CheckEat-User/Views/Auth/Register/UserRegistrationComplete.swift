//
//  BusinessRegistrationComplete.swift
//  CheckEat-Business
//
//  Created by Hee  on 7/10/25.
//

import SwiftUI

struct UserRegistrationComplete: View {
    
    @State private var goToLogin: Bool = false
    
    var body: some View {
        VStack {
            Spacer()

            Image("CheckMark")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundStyle(.green)
                .padding(.bottom)

            Group {
                Text("회원가입이")
                Text("완료되었습니다.")
            }
            .bold20()

            Spacer()

            Button {
                goToLogin = true
            } label: {
                Text("로그인")
                    .primaryButtonStyle()
                    .semibold16()
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            .fullScreenCover(isPresented: $goToLogin) {
                LoginView()
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

//#Preview {
//    UserRegistrationComplete()
//}
