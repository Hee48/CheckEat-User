//
//  Untitled.swift
//  CheckEat-User
//
//  Created by Hee  on 7/17/25.
//

import SwiftUI

struct LoginView: View {
    
    var onLoginSuccess: () -> Void = {}
    var allowsDismiss: Bool = true
    @State private var isPasswordVisible: Bool = false
    @State private var showFindId: Bool = false
    @State private var showFindPwd: Bool = false
    @State private var showJoin: Bool = false
    @StateObject private var viewModel = LoginViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading) {
                    Text("Login")
                        .bold20()
                        .padding(.vertical, 35)
                    
                    Text("label_id")
                        .semibold16()
                    UnderLinedTextField(placeholder: "placeholder_id", text: $viewModel.loginId)
                        .regular14()
                        .keyboardType(.asciiCapable)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .padding(.bottom)
                    
                    Text("label_password")
                        .semibold16()
                    
                    Group {
                        if isPasswordVisible {
                            UnderLinedTextField(placeholder: "placeholder_password", text: $viewModel.password)
                                .textContentType(.password)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        } else {
                            UnderLinedTextField(placeholder: "placeholder_password", isSecure: true, text: $viewModel.password)
                                .textContentType(.password)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .tapToDismissKeyboard()
                        }
                    }
                    .regular14()
                    .padding(.bottom)
                    .overlay(alignment: .trailing) {
                        Button {
                            isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                .frame(width: 16, height: 16)
                                .foregroundColor(.buttonOP50)
                                .padding(.bottom, 30)
                                .padding(.trailing, 8)
                                .contentShape(Rectangle())
                        }
                    }
                    
                    Text(LocalizedStringKey(viewModel.alertMessage))
                        .regular12()
                        .foregroundStyle(.red)
                        .padding(.bottom, 24)
                    
                    
                    Button {
                        viewModel.login()
                    } label: {
                        Text("Login")
                            .primaryButtonStyle()
                            .semibold16()
                    }
                    .onChange(of: viewModel.loginSuccess) { success in
                        guard success else { return }
                        onLoginSuccess() // 외부에서 dismiss 처리
                    }
                    .onAppear {
                        viewModel.reset()
                    }
                    
                    HStack {
                        Spacer()
                        Button {
                            showFindId = true
                        } label: {
                            Text("action_find_id")
                                .foregroundStyle(.buttonOP50)
                        }
                        .fullScreenCover(isPresented: $showFindId) {
                            FindIDView(showFindId: $showFindId, showFindID: $showFindId, showFindPw: $showFindPwd)
                        }
                        Text(" | ")
                            .foregroundStyle(.buttonOP50)
                        Button {
                            showFindPwd = true
                        } label: {
                            Text("action_reset_password")
                                .foregroundStyle(.buttonOP50)
                        }
                        .fullScreenCover(isPresented: $showFindPwd) {
                            FindPwdView(showFindPwd: $showFindPwd, showFindID: showFindId)
                        }
                        Spacer()
                    }
                    .regular14()
                    .padding()
                    
                    
                    Spacer()
                }
                .padding()
            }
            .tapToDismissKeyboard()
            .safeAreaInset(edge: .bottom) {
                VStack {
                    HStack {
                        Spacer()
                        Text("label_not_member_yet")
                            .regular14()
                        Button {
                            showJoin = true
                        } label: {
                            Text("action_join")
                                .semibold14()
                                .foregroundStyle(.buttonAuth)
                        }
                        .fullScreenCover(isPresented: $showJoin) {
                            JoinView(showJoin: $showJoin)
                        }
                        Spacer()
                    }
                    .padding(.vertical)
                }
                .padding(.horizontal)
            }
            .ignoresSafeArea(.keyboard)
            .navigationTitle("Login")
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled(!allowsDismiss)
            .toolbar {
                if allowsDismiss {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        }
    }
}
