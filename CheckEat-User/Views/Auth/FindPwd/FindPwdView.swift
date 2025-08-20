//
//  FindPwdView.swift
//  CheckEat-Business
//
//  Created by 최준영 on 7/5/25.
//

import SwiftUI

struct FindPwdView: View {

    // MARK: 스크린 상태 값
    @Binding var showFindPwd: Bool
    @State var showFindID: Bool
    // MARK: 하위 경로 스택
    @State var path: [FindPwdRoute] = []
    
    //MARK: 아이디, 이메일, 인증코드 필드 초기 세팅
    @State private var userId: String = ""
    @State private var userEmail: String = ""
    @State private var authCode: String = ""
    @State private var infoMsg = "enter_registered_id_email"
    //MARK: 키보드 dismiss와 비슷한 동작
    @FocusState private var fieldIsFocused: Bool
    
    //MARK: 인증코드 입력 필드 노출 여부
    @State private var isFieldVisible: Bool = false
    //MARK: 인증코드 입력 제한시간 타이머 설정
    @State private var timeRemaining = 180
    @State private var timerActive: Bool = false
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    //MARK: 인증코드 유효성
    @State private var authCodeIsValid: Bool? = nil
    private var canRequestAuthCode: Bool { // 공백이거나 비어있는지 검증
        !authCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    //MARK: 아이디, 이메일 유효성
    private var isUserIdValid: Bool {
        !userId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    @State private var isEmailValid: Bool = false // 이메일 양식 준수
    private var isUserEmailValid: Bool { // 공백이거나 비어있는지 검증
        !userEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && isEmailValid
    }
    //MARK: 인증을 위한 유효성 검증 (활성화)
    private var canRequestCode: Bool {
        isUserIdValid && isUserEmailValid
    }
    //MARK: 뷰모델
    @StateObject private var viewModel = FindPwdViewModel()
    
    var body: some View {
        
        NavigationStack(path: $path) {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        FindHeaderView(title: LocalizedStringKey("forgot_password_title"), subtitle: LocalizedStringKey(infoMsg))
                        
                        Text("user_id_label")
                            .semibold16()
                        UnderLinedTextField(placeholder: "user_id_placeholder", text: $userId)
                            .regular14()
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .focused($fieldIsFocused)
                            .padding(.bottom)
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
                        Spacer()
                        VStack {
                            if !isFieldVisible {
                                //MARK: 인증코드 필드가 안 보이고 있을 경우, 버튼을 통해 보이게 전환
                                //인증코드 받기 버튼 클릭시 이메일 유효성 결과를 바탕으로 인증코드 발송
                                AuthCodeRequestButton(
                                    isUserEmailValid: isUserEmailValid,
                                    infoMsg: $infoMsg,
                                    isFieldVisible: $isFieldVisible,
                                    authCodeIsValid: $authCodeIsValid,
                                    resendCode: resendCode
                                )
                            } else {
                                AuthCodeInputSectionPwd(
                                    viewModel: viewModel,
                                    path: $path,
                                    userId: $userId,
                                    userEmail: $userEmail,
                                    authCode: $authCode,
                                    authCodeIsValid: $authCodeIsValid,
                                    canRequestAuthCode: canRequestAuthCode,
                                    fieldIsFocused: $fieldIsFocused,
                                    timerActive: timerActive,
                                    timeRemaining: timeRemaining,
                                    formatTime: formatTime,
                                    resendCode: resendCode)
                            }
                        }
                        .animation(.easeInOut(duration: 0.5), value: isFieldVisible)
                        .padding(.vertical)
                        
                    }
                    .padding(.horizontal)
                }
                .onTapGesture {
                    fieldIsFocused = false
                }
            }
            .ignoresSafeArea(.keyboard)
            .navigationTitle("reset_password_title")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showFindPwd = false
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(.black)
                    }
                }
            }
            .navigationDestination(for: FindPwdRoute.self) { route in
                switch route {
                case .inputNewPwd:
                    ChangePasswordView(showFindPwd: $showFindPwd, showFindID: $showFindID, path: $path, userEmail: $userEmail, viewModel: viewModel)
                case .findPwdComplete:
                    ChangePasswordCompleteView(showFindPwd: $showFindPwd, showFindID: $showFindID)
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack {
                    HStack {
                        Text("remember_password_question")
                            .regular14()
                        Button {
                            showFindPwd = false
                        } label: {
                            Text("Login")
                                .semibold14()
                                .foregroundStyle(.buttonAuth)
                        }
                    }
                }
                .ignoresSafeArea(.keyboard)
                .padding(.bottom, 24)
            }
            .onReceive(timer) { _ in
                guard timerActive else { return }
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    timerActive = false
                }
            }
        }
        
    }
    
    //MARK: 타이머 관련
    func formatTime(_ seconds: Int)-> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
    func startTimer() {
        timeRemaining = 180
        timerActive = true
    }
    
    //MARK: 비밀번호 찾기 인증번호 발송
    func resendCode() {
        //TODO: 비밀번호 찾기 인증번호 로직 추가 완료
        viewModel.sendEmailToken(email: userEmail, logId: userId)
        startTimer()
    }
    
    //MARK: 이메일 양식 준수 설정
    func isValidEmailAddress(email: String) {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        isEmailValid = emailPredicate.evaluate(with: email)
    }
}
