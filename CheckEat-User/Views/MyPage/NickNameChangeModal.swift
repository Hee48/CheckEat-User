//
//  NickNameChange.swift
//  CheckEat-User
//
//  Created by Hee  on 8/3/25.
//

import SwiftUI

struct NickNameChangeModal:View {
    @StateObject private var viewModel = NickNameChangeViewModel()
    @ObservedObject var myPageViewModel: MyPageViewModel
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(alignment: .leading) {
            Text("nickname_change_title".localized)
                .bold20()
            TextField("nickname_change_placeholder".localized, text: $viewModel.newNickName)
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
                myPageViewModel.loadUserInfoFromToken()
                dismiss()
            } label: {
                Text("nickname_change_button".localized)
                    .primaryButtonStyle(isEnabled: true)
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 362)
            }
            .padding(.top, 20)
        }
        .padding(.leading, 5)
    }
}
