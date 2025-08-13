//
//  MyPageHeaderView.swift
//  CheckEat-Business
//
//  Created by 최준영 on 7/16/25.
//

import SwiftUI

struct MyPageHeaderView: View {
    
    @ObservedObject var myPageViewModel: MyPageViewModel

    @Binding var showMoreMenu: Bool
    @Binding var showNickNameChangeModal: Bool
    @Binding var showImageChangeModal: Bool

    @State private var profileImageName: String = UserDefaults.standard.string(forKey: "profileImageName") ?? "user1"

    
    var body: some View {
        HStack(alignment: .top) {
            Button {
                showImageChangeModal = true
            } label: {
                Image(profileImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 1))
                    .padding(.trailing, 10)
            }
            .foregroundStyle(.primary)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    Button {
                        showNickNameChangeModal = true
                    } label: {
                        Text(myPageViewModel.userInfo?.nickName ?? "")
                            .bold20()
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Button {
                        withAnimation { showMoreMenu.toggle() }
                    } label: {
                        Image("More")
                    }
                }
                
                Text(myPageViewModel.userInfo?.email ?? "")
                    .regular16()
                    .foregroundColor(.buttonAuth)
            }
        }
        .padding(.vertical, 35)
        .padding(.horizontal)
        .sheet(isPresented: $showImageChangeModal) {
            UserImageChange(selectedImageName: $profileImageName)
                .presentationDetents([.height(380), .medium])
        }
        .onChange(of: profileImageName) { newValue in
            UserDefaults.standard.set(newValue, forKey: "profileImageName")
        }
   
    }
}
