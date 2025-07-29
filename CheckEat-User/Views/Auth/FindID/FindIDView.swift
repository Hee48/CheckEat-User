//
//  FindIDView.swift
//  CheckEat-Business
//
//  Created by 최준영 on 7/10/25.
//

import SwiftUI

struct FindIDView: View {
    
    @State private var userEmail: String = ""
    @State private var authCode: String = ""
    @State private var infoMsg = "가입시 등록하신 이메일을 입력해주세요."
    
    @State private var isFieldVisible: Bool = false
    @State private var authCodeIsValid: Bool? = nil
    @State private var isEmailValid: Bool = false
    @State private var goFindIDComplete = false
    @State private var goToLogin: Bool = false
    
    @State private var timeRemaining = 30
    @State private var timerActive: Bool = false
    
    @FocusState private var fieldIsFocused: Bool
    @StateObject private var viewModel = FindIDViewModel()
    
    @Environment(\.dismiss) private var dismiss
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var isUserEmailValid: Bool {
        !userEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && isEmailValid
    }
    
    private var canRequestAuthCode: Bool {
        !authCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("아이디를 잊으셨나요?")
                            .bold20()
                            .padding(.top, 35)
                            .padding(.bottom, 3)
                        
                        Text(infoMsg)
                            .regular16()
                            .padding(.bottom, 35)
                        
                        Text("이메일")
                            .semibold16()
                        UnderLinedTextField(placeholder: "이메일을 입력해주세요", text: $userEmail)
                            .regular14()
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .focused($fieldIsFocused)
                            .onChange(of: userEmail) { newValue in
                                isValidEmailAddress(email: newValue)
                            }
                    }
                    .navigationTitle("아이디 찾기")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.backward")
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                    
                    VStack {
                        Group {
                            if !isFieldVisible {
                                Button {
                                    infoMsg = "입력하신 이메일로 인증코드를 전송했습니다."
                                    isFieldVisible = true
                                    authCodeIsValid = nil
                                    resendCode()
                                } label: {
                                    Text("인증코드 받기")
                                        .primaryButtonStyle(isEnabled: isUserEmailValid)
                                        .semibold16()
                                }
                                .disabled(!isUserEmailValid)
                                .padding(.top, 24)
                                
                            } else {
                                VStack(alignment: .leading) {
                                    Text("인증코드")
                                        .semibold16()
                                    UnderLinedTextField(placeholder: "인증코드를 입력해주세요", text: $authCode)
                                        .regular14()
                                        .focused($fieldIsFocused)
                                    
                                    if authCodeIsValid == false {
                                        VStack(alignment: .leading) {
                                            Text("잘못된 코드입니다. 다시 시도해주세요.")
                                                .regular12()
                                                .foregroundStyle(.red)
                                        }
                                    }
                                    if timerActive {
                                        HStack {
                                            Spacer()
                                            Button {
                                                resendCode()
                                            } label: {
                                                Text("인증코드 다시 보내기")
                                                    .bold14()
                                                    .foregroundStyle(.buttonAuth)
                                            }
                                            Text(formatTime(timeRemaining))
                                                .monospacedDigit()
                                                .regular14()
                                            Spacer()
                                        }
                                        .padding(.vertical, 24)
                                    } else {
                                        HStack {
                                            Spacer()
                                            Text("인증코드를 받지 못했어요")
                                                .regular14()
                                            Button {
                                                authCode = ""
                                                authCodeIsValid = nil
                                                resendCode()
                                            } label: {
                                                Text("인증코드 다시 받기")
                                                    .bold14()
                                                    .foregroundStyle(.buttonAuth)
                                            }
                                            Spacer()
                                        }
                                        .padding(.vertical, 24)
                                    }
                                    
                                }
                                HStack {
                                    Button {
                                        viewModel.checkFindId(email: userEmail, token: authCode)
                                    } label: {
                                        Text("완료")
                                            .primaryButtonStyle(isEnabled: canRequestAuthCode)
                                            .semibold16()
                                    }
                                    .disabled(authCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                                    .onChange(of: viewModel.findIdTokenSuccess) { newValue in
                                        if newValue == true {
                                            authCodeIsValid = true
                                            goFindIDComplete = true
                                        } else if newValue == false {
                                            authCodeIsValid = false
                                        }
                                    }
                                    .fullScreenCover(isPresented: $goFindIDComplete) {
                                        if let userID = viewModel.foundUserId {
                                            FindIDComplete(userID: userID)
                                        }
                                    }
                                }
                            }
                        }
                        .offset(y: isFieldVisible ? 0 : -30)
                    }
                    .animation(.easeInOut(duration: 0.5), value: isFieldVisible)
                    .padding(.vertical)
                }
                .onTapGesture {
                    fieldIsFocused = false
                }
                .scrollDismissesKeyboard(.interactively)
                .safeAreaInset(edge: .bottom) {
                    VStack {
                        HStack {
                            Text("아이디가 기억나셨나요?")
                                .regular14()
                            Button {
                                goToLogin = true
                            } label: {
                                Text("로그인")
                                    .semibold14()
                                    .foregroundStyle(.buttonAuth)
                            }
                        }
                        .fullScreenCover(isPresented: $goToLogin) {
                            LoginView()
                        }
                    }
                    .padding(.bottom)
                }
                .ignoresSafeArea(.keyboard)
                .onReceive(timer) { _ in
                    guard timerActive else { return }
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    } else {
                        timerActive = false
                    }
                }
            }
            .padding(.horizontal)
        }
        
    }
    
    func formatTime(_ seconds: Int)-> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
    
    func startTimer() {
        timeRemaining = 30
        timerActive = true
    }
    //아이디찾기 인증번호 발송
    func resendCode() {
        viewModel.findId(email: userEmail, language: "ko")
        startTimer()
    }
    func isValidEmailAddress(email: String) {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        isEmailValid = emailPredicate.evaluate(with: email)
    }
}

#Preview {
    FindIDView()
}
