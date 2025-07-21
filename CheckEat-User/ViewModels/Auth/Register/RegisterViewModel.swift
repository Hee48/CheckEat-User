//
//  RegisterViewModel.swift
//  CheckEat-User
//
//  Created by Hee  on 7/17/25.
//

import Foundation
import Alamofire
import Combine
import SwiftUI

class RegisterViewModel: ObservableObject {
    @Published var loginId: String = ""
    @Published var password: String = ""
    @Published var email: String = ""
    @Published var nickName: String = ""
    @Published var allergy: String = ""
    @Published var selectedVeganLevel: VeganLevel = .none
    @Published var selectedHalalStatus: HalaStatus = .no
    @Published var selectedCommonAllergies: Set<Int> = []
    
    //이메일 인증 관련
    @Published var emailVerificationToken = ""
    
    //중복 확인 상태
    @Published var isIdAvailable = false
    @Published var isEmailAvailable = false
    
    @Published var alertItem: AlertItem?
    
    private var cancellables = Set<AnyCancellable>()
    
    //아이디 중복확인
    func checkIdUnique(id: String) {
          RegisterSerivce.checkIDUnique(id: id)
              .receive(on: DispatchQueue.main)
              .sink { completion in
                  switch completion {
                  case .finished:
                      print("아이디 중복확인 완료 ✅")
                  case .failure(let error):
                      print("아이디 중복확인 실패 ❌❌❌ \(error.localizedDescription)")
                  }
              } receiveValue: { [weak self] response in
                  self?.isIdAvailable = response.status == 200
                  if response.status == 200 {
                      self?.alertItem = AlertItem(title: "성공", message: "아이디 사용 가능합니다.", dissmissButton: .default(Text("확인")))
                      print("아이디 사용 가능 ✅")
                  } else {
                      print("아이디 중복됨 : \(response.message)")
                      self?.alertItem = AlertItem(title: "실패", message: "아이디가 중복입니다 확인해주세요.", dissmissButton: .default(Text("확인")))
                  }
              }
              .store(in: &cancellables)
      }
      
    //이메일 중복확인
    func checkEmailUnique(email: String, completion: @escaping () -> Void) {
          RegisterSerivce.checkEmailUnique(email: email)
              .receive(on: DispatchQueue.main)
              .sink { [weak self] completion in
                  switch completion {
                  case .finished:
                      print("이메일 중복확인 완료 ✅")
                  case .failure(let error):
                      print("이메일 중복확인 실패 ❌❌❌ \(error.localizedDescription)")
                      self?.alertItem = AlertItem(title: "이메일 중복 확인 실패", message: error.localizedDescription, dissmissButton: .default(Text("확인")))
                  }
              } receiveValue: { [weak self] response in
                  if response.status == 200 {
                      print("이메일 사용 가능 ✅")
                      completion()
                      self?.alertItem = AlertItem(title: "사용 가능", message: "이 이메일은 사용 가능합니다.", dissmissButton: .default(Text("확인")))
                      self?.sendEmailToken(email: email, language: "ko")
                  } else {
                      print("이메일 중복돰: \(response.message)")
                      self?.alertItem = AlertItem(title: "중복된 이메일 입니다", message: "이메일을 다시 확인 해주세요.", dissmissButton: .default(Text("확인")))
                  }
              }
              .store(in: &cancellables)
      }
      
      //이메일 인증 토큰 발송
    func sendEmailToken(email: String, language: String) {
          RegisterSerivce.sendEmailToken(email: email, language: language)
              .receive(on: DispatchQueue.main)
              .sink { completion in
                  switch completion {
                  case .finished:
                      print("이메일 인증토큰 발송 완료 ✅")
                  case .failure(let error):
                      print("이메일 인증토큰 발송 실패 ❌❌❌ \(error.localizedDescription)")
                  }
              } receiveValue: { [weak self] response in
                  if response.status == 200 {
                      print("이메일 발송 성공 ✅")
                  } else {
                      print("이메일 발송 실패: \(response.message)")
                  }
              }
              .store(in: &cancellables)
      }
      
      //이메일 인증 토큰 확인
    func verifyEmailToken(email: String, token: String) {
          print("📨 인증 요청 - email: \(email), token: \(token)")
        
          RegisterSerivce.checkEmailToken(email: email, token: token)
              .receive(on: DispatchQueue.main)
              .sink { completion in
                  switch completion {
                  case .finished:
                      print("이메일 인증토큰 확인 ✅")
                  case .failure(let error):
                      print("이메일 인증토큰 실패 ❌❌❌ \(error.localizedDescription)")
                  }
              } receiveValue: { [weak self] response in
                  if response.status == "success" {
                      self?.alertItem = AlertItem(title: "성공", message: "이메일 인증이 완료되었습니다.", dissmissButton: .default(Text("확인")))
                      print("이메일 인증 성공 ✅")
                  } else {
                      self?.alertItem = AlertItem(title: "실패", message: "이메일 인증코드를 다시 확인해주세요.", dissmissButton: .default(Text("확인")))
                      print("이메일 인증 실패: \(response.message)")
                  }
              }
              .store(in: &cancellables)
      }
      
      //회원가입
    func signUp(completion: @escaping (Bool) -> Void) {
          print("📩 signUp 호출됨 - loginId: \(loginId), email: \(email), password: \(password), nickName: \(nickName)")
          let request = RegisterRequest(
              log_Id: loginId,
              log_pwd: password,
              email: email,
              allergy: allergy.isEmpty ? nil : allergy,
              nickname: nickName,
              commonAllergies: selectedCommonAllergies.isEmpty ? nil : Array(selectedCommonAllergies),
              vegan: selectedVeganLevel.rawValue,
              isHalal: selectedHalalStatus.rawValue
          )
          
          RegisterSerivce.signUp(request: request)
              .receive(on: DispatchQueue.main)
              .sink { completion in
                  switch completion {
                  case .finished:
                      print("회원 가입 확인 ✅")
                  case .failure(let error):
                      print("회원 가입중 오류가 발생 ❌❌❌ \(error.localizedDescription)")

                  }
              } receiveValue: { response in
                  if response.status == 201 {
                      print("회원 가입이 완료되었습니다 ✅")
                      completion(true)
                  } else {
                      print("회원 가입이 실패되었습니다 : \(response.message)")
                      completion(false)
                  }
              }
              .store(in: &cancellables)
      }
      
    
}
