//
//  FindIDViewStep1.swift
//  CheckEat-Business
//
//  Created by 최준영 on 7/5/25.
//
import SwiftUI


struct FindIDViewOrigin: View {
    @State var email: String = ""
    @State private var showVerificationField = false
    @State private var verificationCode = ""
    @State private var isVerificationCodeValid: Bool = false
    @State private var timeRemaining = 30
    @State private var timerActive = false
    @State private var infoMessage = "가입시 등록하신 이메일을 입력해주세요."
    @State private var isEmailValid: Bool = false
    @State private var goFindIDComplete = false
    @State private var showCodeErrorMessage: Bool = false
    @State private var goToLogin: Bool = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var isButtonEnabled: Bool {
        if showVerificationField {
            return isEmailValid && !verificationCode.isEmpty
        } else {
            return isEmailValid
        }
    }
    var body: some View {
        GeometryReader { _ in
            NavigationStack {
                VStack (alignment: .leading) {
                    Text("아이디를 잊으셨나요?").font(.system(size: 20,weight: .bold))
                        .padding(.top, 3)
                    Text(infoMessage)
                        .font(.system(size: 16, weight: .light))
                        .padding(.top, 3)
                    Text("이메일")
                        .font(.system(size: 14, weight: .bold))
                        .padding(.top, 20)
                    UnderLinedTextField(placeholder: "이메일을 입력해 주세요.", text: $email)
                        .keyboardType(.emailAddress)
                        .onChange(of: email) { newValue in
                            isEmailValid = isValidEmailAddress(email: newValue)
                        }
                        .font(.system(size: 14))
                        .padding(.top, 2)
                        .padding(.trailing)
                    
                    if showVerificationField {
                        VStack(alignment: .leading){
                            Text("인증코드")
                                .font(.system(size: 14, weight: .bold))
                                .padding(.top, 10)
                            UnderLinedTextField(placeholder: "인증코드를 입력해 주세요.", text: $verificationCode)
                                .onChange(of: verificationCode){ newValue in
                                    isVerificationCodeValid = (newValue == "1234")
                                    showCodeErrorMessage = !isVerificationCodeValid && !newValue.isEmpty
                                }
                                .font(.system(size: 14))
                                .padding(.top, 2)
                            
                            if showCodeErrorMessage {
                                Text("잘못된 코드입니다. 다시 시도해 주세요.")
                                    .foregroundColor(.red)
                                    .font(.system(size: 12))
                            }
                            
                        }
                        HStack(spacing: 8) {
                            Button {
                                resendCode()
                            } label: {
                                if timerActive {
                                    Text("인증코드 다시 보내기")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(Color("Button_OP70"))
                                        .padding(.top, 20)
                                        .padding(.leading, 80)
                                } else {
                                    (Text("인증코드를 받지 못했어요  ")
                                        .font(.system(size: 16, weight: .light)) +
                                     Text("  인증코드 다시받기")
                                        .font(.system(size: 16, weight: .bold)))
                                    .foregroundColor(Color.black)
                                    .padding(.top, 20)
                                    .padding(.leading, 30)
                                }
                            }
                            if timerActive {
                                Text(formatTime(timeRemaining))
                                    .font(.system(size: 16))
                                    .foregroundColor(Color("Button_OP70"))
                                    .padding(.top, 20)
                            }
                        }
                    }
                    Button {
                        if showVerificationField {
                            if isVerificationCodeValid {
                                goFindIDComplete = true
                            }
                        } else {
                            withAnimation {
                                showVerificationField = true
                                startTimer()
                                infoMessage = "입력하신 이메일로 인증코드를 전송했습니다."
                            }
                        }
                        
                    } label: {
                        Text(showVerificationField ? "완료" : "인증코드 받기")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .primaryButtonStyle(isEnabled: isButtonEnabled)
                            .padding(.trailing)
                            .padding(.top, 24)
                    }
                    .disabled(!isButtonEnabled)
                    .fullScreenCover(isPresented: $goFindIDComplete) {
                        FindIDComplete(userID: "test1234")
                    }
                    Spacer()
                    
                }
                .padding(.top, 50)
                .padding(.leading, 15)
                .navigationTitle("아이디 찾기")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            goToLogin = true
                        } label: {
                            Image(systemName: "chevron.backward")
                                .foregroundStyle(.black)
                        }
                        .fullScreenCover(isPresented: $goToLogin) {
                            LoginView()
                        }
                    }
                }
                VStack(alignment: .center) {
                    Button {
                        goToLogin = true
                    } label: {
                        Text("아이디가 기억나셨나요? ").font(.system(size: 14 ,weight: .light))
                            .foregroundStyle(Color.black) +
                        Text(" 로그인").font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.black)
                    }
                    .padding(.bottom, 30)
                    .fullScreenCover(isPresented: $goToLogin) {
                        LoginView()
                    }
                }
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
    
    func formatTime(_ seconds: Int)-> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
    
    func startTimer() {
        timeRemaining = 30
        timerActive = true
    }
    func resendCode() {
        //인증 재요청 로직
        startTimer()
    }
    func isValidEmailAddress(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
}

#Preview {
    FindIDViewOrigin()
}
