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
            Text("인증코드")
                .font(.system(size: 14, weight: .semibold))
                .padding(.top, 10)
            UnderLinedTextField(placeholder: "인증코드를 입력해 주세요.", text: $verificationCode)
                .onChange(of: verificationCode){ newValue in
                    isVerificationCodeValid = (newValue == "1234")
                    showCodeErrorMessage = !isVerificationCodeValid && !newValue.isEmpty
                }
                .font(.system(size: 14))
                .padding(.top, 2)
            
            if showCodeErrorMessage {
                Text("잘못된 코드입니다. 다시 시도해 주세요.")
                    .foregroundColor(.red)
                    .font(.system(size: 12))
            }
            HStack(spacing: 8) {
                Button {
                    resendCodeAction()
                } label: {
                    if timerActive {
                        Text("인증코드 다시 보내기")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color("Button_OP70"))
                            .padding(.top, 20)
                            .padding(.leading, 80)
                    } else {
                        (Text("인증코드를 받지 못했어요  ")
                            .font(.system(size: 16, weight: .light)) +
                         Text("  인증코드 다시받기")
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
    //
    //#Preview {
    //    VerificationCodeSection()
    //}

