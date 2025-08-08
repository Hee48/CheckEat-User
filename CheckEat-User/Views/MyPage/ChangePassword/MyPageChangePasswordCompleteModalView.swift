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
                Text("비밀번호 변경이")
                Text("완료되었습니다.")
            }
            .bold20()
            
            Text("새로운 비밀번호로 로그인해주세요.")
                .padding(.vertical, 8)
            
            Button {
                dismissParent()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        dismiss()
                    }
            } label: {
                Text("닫기")
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
