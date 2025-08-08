//
//  ChangePasswordCompleteView.swift
//  CheckEat-Business
//
//  Created by 최준영 on 7/5/25.
//

import SwiftUI

struct ChangePasswordCompleteView: View {
    
    // MARK: 스크린 상태 값
    @Binding var showFindPwd: Bool
    // MARK: 하위 경로 스택
    @State var path: [FindPwdRoute] = []
    
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
                showFindPwd = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    path.removeAll()
                }
            } label: {
                Text("로그인")
                    .primaryButtonStyle()
                    .semibold16()
                    .padding(.vertical, 24)
            }
        }
        .padding()
        .padding(.bottom, 200)
        .navigationBarBackButtonHidden(true)
    }
}
