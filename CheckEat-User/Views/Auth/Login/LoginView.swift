//
//  Untitled.swift
//  CheckEat-User
//
//  Created by Hee  on 7/17/25.
//

import SwiftUI

struct LoginView: View {
    
 
    var onLoginSuccess: () -> Void = {}
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
                    Text("로그인")
                        .bold20()
                        .padding(.vertical, 35)
                    
                    Text("아이디")
                        .semibold16()
                    UnderLinedTextField(placeholder: "아이디를 입력해주세요", text: $viewModel.loginId)
                        .regular14()
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .padding(.bottom)
                    
                    Text("비밀번호")
                        .semibold16()
                    HStack {
                        Group {
                            if isPasswordVisible {
                                UnderLinedTextField(placeholder: "비밀번호를 입력해주세요", text: $viewModel.password)
                                    .textContentType(.password)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                            } else {
                                UnderLinedTextField(placeholder: "비밀번호를 입력해주세요", isSecure: true, text: $viewModel.password)
                                    .textContentType(.password)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .tapToDismissKeyboard()
                            }
                        }
                        .padding(.bottom)
                        
                        Button {
                            isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                .foregroundColor(.gray)
                                .padding(8)
                                .contentShape(Rectangle())
                        }
                    }
                    .regular14()
                    Text(viewModel.alertMessage)
                        .regular12()
                        .foregroundStyle(.red)
                        .padding(.bottom, 24)
                    
                    
                    Button {
                        viewModel.login()
                    } label: {
                        Text("로그인")
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
                            Text("아이디 찾기")
                                .foregroundStyle(.buttonOP50)
                        }
                        .fullScreenCover(isPresented: $showFindId) {
                            FindIDView(showFindId: $showFindId)
                        }
                        Text(" | ")
                            .foregroundStyle(.buttonOP50)
                        Button {
                            showFindPwd = true
                        } label: {
                            Text("비밀번호 재설정")
                                .foregroundStyle(.buttonOP50)
                        }
                        .fullScreenCover(isPresented: $showFindPwd) {
                            FindPwdView(showFindPw: $showFindPwd)
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
                        Text("아직 회원이 아니신가요?")
                            .regular14()
                        Button {
                            showJoin = true
                        } label: {
                            Text("회원가입")
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
            .navigationTitle("로그인")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
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
