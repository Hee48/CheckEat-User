//
//  MyPageView.swift
//  CheckEat-Business
//
//  Created by 최준영 on 7/14/25.
//

import SwiftUI

struct MyPageView: View {
    
    @State private var nickName: String = "닉네임"
    @State private var userEmail: String = "test@email.com"
    @State private var goToLogin: Bool = false
    @State private var showWithdrawAlert: Bool = false
    @State private var showDeleteCompany: Bool = false
    @State private var showChangePasswordModal = false
    @State private var showManageCompanyModal = false
    
    @State private var showMoreMenu = false
    @State private var moreMenuAnchor = CGRect.zero
    
    @State private var selectedDestination: SettingDestination? = nil
    @State private var isPresented: Bool = false
    @State private var showVisitedStores = false
    @State private var showReviewCreated = false
    @State private var showEditAllergies = false
    @State private var showLanguageSettings = false
    
    @State private var showToast = false
    @State private var toastMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        
                        MyPageHeaderView(
                            nickName: nickName,
                            userEmail: userEmail,
                            showMoreMenu: $showMoreMenu,
                            showManageCompanyModal: $showManageCompanyModal
                        )
                        
                        Rectangle()
                            .fill(Color("Button_OP"))
                            .frame(height: 10)
                            .padding(.bottom, 35)
                            .frame(maxWidth: .infinity)
                        
                        MyPageSectionContainerView(
                            handleSelection: handleSelection
                        )
                        
                        Button {
                            goToLogin = true
                        } label: {
                            Text("로그아웃")
                                .semibold14()
                                .foregroundStyle(.buttonOP20)
                                .padding()
                                .padding(.top, 35)
                        }
                        .fullScreenCover(isPresented: $goToLogin) {
                            LoginView()
                        }
                    }
                }
                .alert("회원탈퇴", isPresented: $showWithdrawAlert) {
                    Button("탈퇴", role: .destructive) {
                        //TODO: 실제 탈퇴 처리 로직 (DB, API 등) 후
                        goToLogin = true
                    }
                    Button("취소", role: .cancel) { }
                } message: {
                    Text("정말 회원 탈퇴하시겠습니까?\n탈퇴 시 모든 데이터가 삭제됩니다.")
                }
                
                MyPageMoreMenu(
                    isPresented: $showMoreMenu,
                    actions: [
                        (title: "회원탈퇴", action: { showWithdrawAlert = true })
                    ],
                    anchor: moreMenuAnchor
                )
            }
//            .toast(isPresented: $showToast, message: toastMessage)
            .navigationTitle("마이페이지")
            .navigationBarTitleDisplayMode(.inline)
            
            //MARK: - 모달 뷰로 이어지는 메뉴
            .sheet(isPresented: $showChangePasswordModal) {
                MyPageChangePasswordModalView()
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.height(450)])
            }
            //여기서 밑에 전부 API데이터 받아서 전달해야함
            .fullScreenCover(isPresented: $showVisitedStores) {
                VisitedStores()
            }
            .fullScreenCover(isPresented: $showReviewCreated) {
                ReviewCreated()
            }
            .fullScreenCover(isPresented: $showEditAllergies) {
                EditAllergiesView(selectedAllergyIDs: [1, 3, 7], customAllergyText: "강아지털", onConfirm: { ids, text in })
            }
            .fullScreenCover(isPresented: $showLanguageSettings) {
                LanguageSettings()
            }
            //TODO: 메뉴별 화면 매칭
            //MARK: - 화면 전환 후, 추가 흐름이 있는 경우, 다음 방식으로 구현
//            .fullScreenCover(isPresented: $isPresented) {
//                MyPageBusinessReRegistration(isPresented: $isPresented, onComplete:
//                {
//                    selectedDestination = nil
//                })
//            }
            //MARK: - 단순 화면 전환이라면 다음 방식으로 구현
//            .fullScreenCover(item: $selectedDestination) { destination in
//                switch destination {
//                case .manageCompany:
//                    ManageCompanyView(onSave: { success in
//                        if success {
//                            toastMessage = "변경사항이 저장되었습니다."
//                        } else {
//                            toastMessage = "저장에 실패했습니다."
//                        }
//                        withAnimation {
//                            showToast = true
//                        }
//                    })
//                case .manageMenu:
//                    EmptyView()
//                case .manageBusinessHours:
//                    ManageBusinessHoursView()
//                case .manageHoliday:
//                    DayOffManagementView()
//                default:
//                    EmptyView() //예외 방지용
//                }
//            }
        }
    }
    
    //선택 이벤트 처리
    private func handleSelection(_ destination: SettingDestination) {
        switch destination {
        case .visitedStores:
            showVisitedStores = true
        case .changePassword:
            showChangePasswordModal = true
        case .reviewCreated:
            showReviewCreated = true
        case .editAllergies:
            showEditAllergies = true
        case .languageSettings:
            showLanguageSettings = true
        }
    }
}

#Preview {
    MyPageView()
}
