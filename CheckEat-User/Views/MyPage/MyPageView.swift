//
//  MyPageView.swift
//  CheckEat-Business
//
//  Created by 최준영 on 7/14/25.
//

import SwiftUI
import Combine

struct MyPageView: View {
    
    @State private var goToLogin: Bool = false
    @State private var showWithdrawAlert: Bool = false
    @State private var showDeleteCompany: Bool = false
    @State private var showChangePasswordModal = false
    @State private var showImageChangeModal = false
    
    @State private var showMoreMenu = false
    @State private var moreMenuAnchor = CGRect.zero
    
    @State private var selectedDestination: SettingDestination? = nil
    @State private var isPresented: Bool = false
    @State private var showFavoriteStores = false
    @State private var showVisitedStores = false
    @State private var showReviewCreated = false
    @State private var showEditAllergies = false
    @State private var showLanguageSettings = false
    @State private var showNickNameChangeModal = false
    
    @State private var selectedStoreID: Int? = nil
    @State private var runTime: String = ""
    
    @StateObject private var deleteViewModel = DeleteViewModel()
    @StateObject var storeMapViewModel = StoreMapViewModel()
    @StateObject var myPageViewModel = MyPageViewModel()
    @StateObject private var reviewCompletedViewModel = VisitedStoreViewModel()
    @Binding var selectedTab: Tab
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        VStack {
            Text("마이페이지")
                .bold18()
            ZStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        
                        MyPageHeaderView(
                            myPageViewModel: myPageViewModel,
                            showMoreMenu: $showMoreMenu,
                            showNickNameChangeModal: $showNickNameChangeModal, showImageChangeModal: $showImageChangeModal
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
                            AuthViewModel.shared.logout()
                            selectedTab = .home
                        } label: {
                            Text("로그아웃")
                                .semibold14()
                                .foregroundStyle(.buttonOP20)
                                .padding()
                                .padding(.top, 35)
                        }
                        .fullScreenCover(isPresented: $goToLogin) {
                            LoginView(onLoginSuccess: { goToLogin = false }, allowsDismiss: false)
                        }
                    }
                }
                .onAppear {
                    myPageViewModel.loadUserInfoFromToken()
                }
                .alert("회원탈퇴", isPresented: $showWithdrawAlert) {
                    Button("탈퇴", role: .destructive) {
                        deleteViewModel.withdrawUser()
                            .receive(on: DispatchQueue.main)
                            .sink(receiveCompletion: { completion in
                                switch completion {
                                case .finished:
                                    TokenManager.shared.clear()
                                    goToLogin = true
                                case .failure(let error):
                                    print("❌ 탈퇴 실패: \(error.localizedDescription)")
                                }
                            }, receiveValue: { })
                            .store(in: &cancellables)
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
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        
        
        //MARK: - 모달 뷰로 이어지는 메뉴
        .sheet(isPresented: $showChangePasswordModal) {
            MyPageChangePasswordModalView()
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(450)])
        }
        .sheet(isPresented: $showNickNameChangeModal, onDismiss: {
            myPageViewModel.loadUserInfoFromToken()
        }) {
            NickNameChangeModal(myPageViewModel: myPageViewModel)
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(270)])
        }
        NavigationLink(
            destination: FavoriteStoreScreenView(isPresented: $showFavoriteStores, selectedStoreId: $selectedStoreID),
            isActive: $showFavoriteStores
        ) {
            EmptyView()
        }
        .navigationDestination(isPresented: $showVisitedStores) {
            VisitedStores()
        }
        .navigationDestination(isPresented: $showReviewCreated) {
            ReviewCreated(viewModel: reviewCompletedViewModel)
        }
        .navigationDestination(isPresented: $showEditAllergies) {
            EditAllergiesView(
                onConfirm: { ids, text in },
                path: .constant(NavigationPath()),
                isPresented: $showEditAllergies
            )
        }
        .navigationDestination(isPresented: $showLanguageSettings) {
            LanguageSettings()
        }
    }
    
    //선택 이벤트 처리
    private func handleSelection(_ destination: SettingDestination) {
        switch destination {
        case .favoriteStores:
            showFavoriteStores = true
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
        case .changeNickName:
            showNickNameChangeModal = true
        }
    }
}
