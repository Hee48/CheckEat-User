//
//  CustomTabBarView.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/29/25.
//

import SwiftUI
import Combine

enum Tab {
    case home, review, myPage
}

enum ReviewPath: Hashable {
    case checkModal
    case reviewQuestionView(storeId: Int)
    case addReivewView(storeId: Int)
}

struct CustomTabBarView: View {
    @Binding var selectedTab: Tab
    @State private var showLogin = false
    @State private var intendedTab: Tab?
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var reviewPath: [ReviewPath] = []
    @State var isReviewFlowActive: Bool = false
    @State private var currentLanguage: String = LanguageSettingsViewModel.getCurrentLanguage()

    var body: some View {
        HStack {
            tabItem(image: "Home", title: "tab_home", tab: .home)
                .frame(maxWidth: .infinity)
            tabItem(image: "Edit", title: "action_write_review", tab: .review)
                .frame(maxWidth: .infinity)
            tabItem(image: "User", title: "tab_mypage", tab: .myPage)
                .frame(maxWidth: .infinity)
        }
        .frame(height: 70)
        .padding(.horizontal, 16)
        
        .shadow(color: Color.black.opacity(0.1), radius: 8, y: -2)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("LanguageChanged"))) { _ in
            currentLanguage = LanguageSettingsViewModel.getCurrentLanguage()
        }
        .id(currentLanguage)
        .fullScreenCover(isPresented: $showLogin) {
            LoginView {
                if let tab = intendedTab {
                    selectedTab = tab
                    authViewModel.checkToken()
                }
                showLogin = false
            }
        }
    }
    private func tabItem(image: String, title: String, tab: Tab) -> some View {
        Button {
            switch tab {
            case .home:
                selectedTab = .home
            case .review, .myPage:
                if authViewModel.isLoggedIn {
                    selectedTab = tab
                } else {
                    intendedTab = tab
                    showLogin = true
                }
            }
        } label: {
            VStack(spacing: 4) {
                Image(image)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(selectedTab == tab ? .black : .gray)
                Text(title.localized)   // ✅ 기기 언어 대신 앱 내 설정으로 변환
                    .regular12()
                    .foregroundColor(selectedTab == tab ? .black : .gray)
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }
}
