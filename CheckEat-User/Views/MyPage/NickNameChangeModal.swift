//
//  NickNameChange.swift
//  CheckEat-User
//
//  Created by Hee  on 8/3/25.
//

import SwiftUI

struct NickNameChangeModal:View {
    @StateObject private var viewModel = NickNameChangeViewModel()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(alignment: .leading) {
            Text("닉네임 변경")
                .bold20()
            TextField("변경하실 닉네임을 입력해주세요.", text: $viewModel.newNickName)
                .regular14()
                .padding(.horizontal, 10)
                .frame(width: 362, height: 52)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .padding(.top, 10)
            
            Button {
                viewModel.newNickName = viewModel.newNickName.trimmingCharacters(in: .whitespacesAndNewlines)
                viewModel.updateNickName()
                dismiss()
                //MARK: - get으로 마이페이지 닉네임 새로 가져와야함
            } label: {
                Text("변경하기")
                    .primaryButtonStyle(isEnabled: true)
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 362)
            }
            .padding(.top, 20)
        }
        .padding(.leading, 5)
    }
}
//#Preview {
//    NickNameChangeModal()
//}
