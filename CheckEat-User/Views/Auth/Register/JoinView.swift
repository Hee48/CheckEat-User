//
//  JoinView.swift
//  CheckEat-Business
//
//  Created by Hee  on 7/7/25.
//

import SwiftUI

struct JoinView: View {
    @State private var id: String = ""
    @State private var password: String = ""
    @State private var isPasswordValid: Bool = false
    @State private var passwordConfirm: String = ""
    @State private var isLengthValid: Bool = false
    @State private var isComplexValid: Bool = false
    @State private var isPasswordVisible: Bool = false
    @State private var isPasswordConfirmVisible: Bool = false
    @State private var verificationCode:String = ""
    @FocusState private var isPasswordFocused: Bool
    @FocusState private var isPasswordConfirmFocused: Bool
    @State private var nickName = ""
    @State private var didSendCode: Bool = false
    @State private var email: String = ""
    @State private var isChecked: Bool = false
    @State private var goUserRegistrationComplete = false
    @StateObject private var viewModel = RegisterViewModel()
    @State private var showAllergy19: Bool = false
    //알러지 전달받는 데이터 배열
    @State private var selectedCommonAllergies: [Int] = []
    @State private var customAllergyText: String = ""
    @Environment(\.dismiss) private var dismiss
    private var isFormValid: Bool {
        return !id.isEmpty && !password.isEmpty && !passwordConfirm.isEmpty && !email.isEmpty && !verificationCode.isEmpty && isChecked
    }
    var body: some View {
        NavigationStack {
            GeometryReader { _ in
                ScrollView {
                    VStack(alignment: .leading, spacing: 4){
                        //아이디,닉네임,비밀번호,비밀번호확인
                        JoinBasicInfoSection(id: $id, password: $password, passwordConfirm: $passwordConfirm, isPasswordVisible: $isPasswordVisible, isPasswordConfirmVisible: $isPasswordConfirmVisible, isPasswordValid: $isPasswordValid, isLengthValid: $isLengthValid, nickName: $nickName, isPasswordFocused: $isPasswordFocused, isPasswordConfirmFocused: $isPasswordConfirmFocused, viewModel: viewModel)
                        //이메일,인증코드,채식구분,할랄여부,알레르기
                        ContactVerificationSection(email: $email, verificationCode: $verificationCode, didSendCode: $didSendCode, viewModel: viewModel, selectedVeganType: $viewModel.selectedVeganLevel, showAllergy19: $showAllergy19, selectedHalalStatus: $viewModel.selectedHalalStatus)
            
    
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                CheckBoxButton(isChecked: $isChecked)
                                    .padding(.top, 10)
                                Text("[필수] 서비스이용약관에 동의합니다.")
                                    .font(.system(size: 14, weight: .medium))
                                    .padding(.top, 10)
                            }
                            .padding(.leading, 17)
                            .padding(.top, 20)
                        }
                        Button {
                            //사용자 입력값 전달
                            viewModel.loginId = id
                            viewModel.password = password
                            viewModel.email = email
                            viewModel.nickName = nickName
                            //임시 테스트 데이터
//                            viewModel.selectedVeganLevel = .none
//                            viewModel.selectedHalalStatus = .no
                            viewModel.allergy = customAllergyText
                            viewModel.selectedCommonAllergies = selectedCommonAllergies
                            // ✅ 서버로 넘기기 전 데이터 확인용 프린트
                               print("🍽️ 회원가입 데이터 확인:")
                               print("- ID: \(viewModel.loginId)")
                               print("- PW: \(viewModel.password)")
                               print("- Email: \(viewModel.email)")
                               print("- Nickname: \(viewModel.nickName)")
                               print("- Vegan: \(viewModel.selectedVeganLevel.rawValue)")
                               print("- Halal: \(viewModel.selectedHalalStatus.rawValue)")
                               print("- Custom Allergy: \(viewModel.allergy)")
                               print("- Common Allergies: \(viewModel.selectedCommonAllergies.sorted())")
                            viewModel.signUp { sucess in
                                if sucess {
                                    goUserRegistrationComplete = true
                                }
                            }
                        } label: {
                            Text("완료")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 362, height: 56, alignment: .center)
                                .background(isFormValid ? Color("Button_Enable") : Color("Button_Disable"))
                                .cornerRadius(6)
                                .padding(.top, 30)
                                .padding(.leading, 20)
                        }
                        .disabled(!isFormValid)
                        .fullScreenCover(isPresented: $goUserRegistrationComplete) {
                            UserRegistrationComplete()
                        }
                        
                        Spacer()
                        
                    }
                    .fullScreenCover(isPresented: $showAllergy19) {
                        Allergy19(
                            allergy: customAllergyText,
                            onSubmit: { ids, text in
                                viewModel.selectedCommonAllergies = ids
                                customAllergyText = text
                                selectedCommonAllergies = ids
                                showAllergy19 = false
                                print("✅ 알러지 정보 저장됨:", ids, text)
                            }
                        )
                    }
                    .alert(item: $viewModel.alertItem, content: { alert in
                        Alert(title: Text(alert.title), message: Text(alert.message),
                              dismissButton: alert.dissmissButton)
                    })
                    .navigationTitle("회원가입")
                    .navigationBarTitleDisplayMode(.inline)
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
                }
            }
        }
    }
}

#Preview {
    JoinView()
}
