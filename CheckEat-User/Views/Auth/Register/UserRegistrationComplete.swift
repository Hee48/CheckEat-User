//
//  BusinessRegistrationComplete.swift
//  CheckEat-Business
//
//  Created by Hee  on 7/10/25.
//

import SwiftUI


struct UserRegistrationComplete: View {
    @Binding var showJoin: Bool
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
                Text("signup_complete_title1")
                Text("signup_complete_title2")
            }
            .bold20()
            
            Spacer()
            
            Button {
                showJoin = false
            }label: {
                Text("Login")
                    .primaryButtonStyle()
                    .semibold16()
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
        .ignoresSafeArea(.keyboard)
    }
}
