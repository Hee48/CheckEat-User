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
    @State private var showManageCompanyModal = false
    
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
    @StateObject private var myPageViewModel = MyPageViewModel()
    @StateObject private var reviewCompletedViewModel = VisitedStoreViewModel()
    @Binding var selectedTab: Tab
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    MyPageHeaderView(
                        nickName: myPageViewModel.userInfo?.nickName ?? "닉네임",
                        userEmail: myPageViewModel.userInfo?.email ?? "test@email.com",
                        showMoreMenu: $showMoreMenu,
                        showManageCompanyModal: $showManageCompanyModal,
                        showNickNameChangeModal: $showNickNameChangeModal
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
                        LoginView()
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
        .navigationTitle("마이페이지")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        
        
        //MARK: - 모달 뷰로 이어지는 메뉴
        .sheet(isPresented: $showChangePasswordModal) {
            MyPageChangePasswordModalView()
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(450)])
        }
        .sheet(isPresented: $showNickNameChangeModal) {
            NickNameChangeModal()
                .presentationDetents([.height(270)])
        }
        NavigationLink(
            destination: FavoriteStoreScreenView(isPresented: $showFavoriteStores, selectedStoreId: $selectedStoreID),
            isActive: $showFavoriteStores
        ) {
            EmptyView()
        }
        
        NavigationLink(
            destination: VisitedStores(),
            isActive: Binding(
                get: { showVisitedStores },
                set: { showVisitedStores = $0 }
            )
        ) {
            EmptyView()
        }
        .hidden()
        NavigationLink(
            destination: ReviewCreated(viewModel: reviewCompletedViewModel),
            isActive: Binding(
                get: { showReviewCreated },
                set: { showReviewCreated = $0 }
            )
        ) {
            EmptyView()
        }
        .hidden()
        NavigationLink(
            destination: EditAllergiesView(
                onConfirm: { ids, text in },
                path: .constant(NavigationPath()),
                isPresented: $showEditAllergies
            ),
            isActive: $showEditAllergies
        ) {
            EmptyView()
        }
        .hidden()
        NavigationLink(
            destination: LanguageSettings(),
            isActive: $showLanguageSettings
        ) {
            EmptyView()
        }
        .hidden()
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
        }
    }
}
//
//#Preview {
//    MyPageView()
//}
