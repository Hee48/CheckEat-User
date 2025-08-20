//
//  VerificationCodeSection.swift
//  CheckEat-Business
//
//  Created by Hee  on 7/9/25.
//

import SwiftUI

struct VerificationCodeSection: View {
    @Binding var verificationCode: String
    @Binding var isVerificationCodeValid: Bool
    @Binding var showCodeErrorMessage: Bool
    @Binding var timeRemaining: Int
    @Binding var timerActive: Bool
    var resendCodeAction: ()-> Void
    var body: some View {
        VStack(alignment: .leading){
            Text("auth_code_title")
                .font(.system(size: 14, weight: .semibold))
                .padding(.top, 10)

            AuthCodeTextField(placeholder: "auth_code_placeholder", text: $verificationCode)

                .font(.system(size: 14))
                .padding(.top, 2)
            
            if showCodeErrorMessage {
                Text("auth_code_invalid")
                    .foregroundColor(.red)
                    .font(.system(size: 12))
            }
            HStack(spacing: 8) {
                Button {
                    resendCodeAction()
                } label: {
                    if timerActive {
                        Text("auth_code_resend")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color("Button_OP70"))
                            .padding(.top, 20)
                            .padding(.leading, 80)
                    } else {
                        (Text("auth_code_not_received")
                            .font(.system(size: 16, weight: .light)) +
                         Text("auth_code_receive_again")
                            .font(.system(size: 16, weight: .semibold)))
                        .foregroundColor(Color.black)
                        .padding(.top, 20)
                        .padding(.leading, 30)
                    }
                }
                if timerActive {
                    Text(formatTime(timeRemaining))
                        .font(.system(size: 16))
                        .foregroundColor(Color("Button_OP70"))
                        .padding(.top, 20)
                }
            }
        }
    }


    
    func formatTime(_ seconds: Int)-> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }

}


