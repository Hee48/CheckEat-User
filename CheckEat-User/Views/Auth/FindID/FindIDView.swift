//
//  FindIDView.swift
//  CheckEat-Business
//
//  Created by 최준영 on 7/10/25.
//

import SwiftUI

enum FindIDPath: Hashable {
    case findIdComplete(userID: String)
}

struct FindIDView: View {
    
    @State private var userEmail: String = ""
    @State private var authCode: String = ""
    @State private var infoMsg: LocalizedStringKey = "enter_registered_email"
    @State private var showCodeErrorMessage: Bool = false
    
    @State private var isFieldVisible: Bool = false
    @State private var authCodeIsValid: Bool? = nil
    @State private var isEmailValid: Bool = false
    
    @State private var timeRemaining = 180
    @State private var timerActive: Bool = false
    
    @FocusState private var fieldIsFocused: Bool
    @StateObject private var viewModel = FindIDViewModel()
    
    @Environment(\.dismiss) private var dismiss
    @State private var findPath: [FindIDPath] = []
    @Binding var showFindId: Bool
    @Binding var showFindID: Bool
    @Binding var showFindPw: Bool
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var isUserEmailValid: Bool {
        !userEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && isEmailValid
    }
    
    private var canRequestAuthCode: Bool {
        !authCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        
        NavigationStack(path: $findPath) {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("find_id_title")
                            .bold20()
                            .padding(.top, 35)
                            .padding(.bottom, 3)
                        
                        Text(infoMsg)
                            .regular16()
                            .padding(.bottom, 35)
                        
                        Text("email_label")
                            .semibold16()
                        UnderLinedTextField(placeholder: "email_placeholder", text: $userEmail)
                            .regular14()
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .focused($fieldIsFocused)
                            .onChange(of: userEmail) { newValue in
                                isValidEmailAddress(email: newValue)
                            }
                    }
                    .navigationTitle("find_id_nav_title")
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
                    .navigationDestination(for: FindIDPath.self) { path in
                        switch path {
                        case .findIdComplete(let userID):
                            FindIDComplete(userID: viewModel.foundUserId, showFindId: $showFindId, showFindPw: $showFindPw, findPath: $findPath)
                        default:
                            EmptyView()
                        }
                    }
                    
                    VStack {
                        Group {
                            if !isFieldVisible {
                                Button {
                                    infoMsg = "find_id_code_sent"
                                    isFieldVisible = true
                                    authCodeIsValid = nil
                                    resendCode()
                                } label: {
                                    Text("find_id_get_code")
                                        .primaryButtonStyle(isEnabled: isUserEmailValid)
                                        .semibold16()
                                }
                                .disabled(!isUserEmailValid)
                                .padding(.top, 24)
                                
                            } else {
                                VStack(alignment: .leading) {
                                    Text("auth_code_title")
                                        .semibold16()

                                    AuthCodeTextField(placeholder: "auth_code_placeholder", text: $authCode)

                                        .regular14()
                                        .focused($fieldIsFocused)
                                    
                                    if showCodeErrorMessage {
                                        VStack(alignment: .leading) {
                                            Text("auth_code_invalid")
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
                                                Text("auth_code_resend")
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
                                            Text("auth_code_not_received")
                                                .regular14()
                                            Button {
                                                authCode = ""
                                                authCodeIsValid = nil
                                                resendCode()
                                            } label: {
                                                Text("auth_code_receive_again")
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
                                        showCodeErrorMessage = false
                                        viewModel.checkFindId(email: userEmail, token: authCode) { success in
                                            if success {
                                                findPath.append(.findIdComplete(userID: viewModel.foundUserId))
                                            } else {
                                                showCodeErrorMessage = true
                                            }
                                        }
                                    } label: {
                                        Text("action_done")
                                            .primaryButtonStyle(isEnabled: canRequestAuthCode)
                                            .semibold16()
                                    }
                                    .disabled(authCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                                   
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
                            Text("remember_id_question")
                                .regular14()
                            Button {
                               dismiss()
                            } label: {
                                Text("Login")
                                    .semibold14()
                                    .foregroundStyle(.buttonAuth)
                            }
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
        timeRemaining = 180
        timerActive = true
    }
    //아이디찾기 인증번호 발송
    func resendCode() {
        viewModel.findId(email: userEmail)
        startTimer()
    }
    func isValidEmailAddress(email: String) {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        isEmailValid = emailPredicate.evaluate(with: email)
    }
}
