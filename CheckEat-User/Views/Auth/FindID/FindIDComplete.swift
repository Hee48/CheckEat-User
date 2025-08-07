//
//  FindIDComplete.swift
//  CheckEat-User
//
//  Created by Hee  on 7/17/25.
//

import SwiftUI

struct FindIDComplete: View {
    let userID: String
    @State var goToFindPwd: Bool = false
    @Binding var showFindId: Bool
    @Binding var showFindPw: Bool
    
    var body: some View {
        
        VStack(spacing: 8) {
            Image("CheckMark")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundStyle(.green)
                .padding(.bottom, 16)
            Text("회원님의 아이디는")
                .foregroundColor(.buttonOP70)
                .medium16()
            Text(userID)
                .font(.system(size: 16, weight: .semibold))
            + Text(" 입니다.")
                .foregroundColor(.buttonOP70)
                .font(.system(size: 16, weight: .medium))
                
            HStack {
                Text("비밀번호를 잊으셨나요?")
                    .foregroundStyle(.buttonOP70)
                    .regular14()
                Button {
                    goToFindPwd = true
                } label: {
                    Text("비밀번호 찾기")
                        .bold14()
                        .foregroundStyle(.buttonAuth)
                }
            }
            .fullScreenCover(isPresented: $goToFindPwd) {
                FindPwdView(showFindPw: $showFindPw)
            }
            .padding(.vertical)
            
            Button {
                showFindId = false
            } label: {
                Text("로그인")
                    .primaryButtonStyle()
                    .semibold16()
            }
            .padding(.vertical, 8)
        }
        .padding()
        .padding(.bottom, 200)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
}
