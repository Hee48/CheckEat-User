//
//  CustomTabBarView.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/29/25.
//
import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedTab: Tab
    
    enum Tab {
        case home, review, myPage
    }
    
    var body: some View {
        HStack {
            tabItem(image: "Home", title: "홈", tab: .home)
                .frame(maxWidth: .infinity)
            tabItem(image: "Edit", title: "리뷰작성", tab: .review)
                .frame(maxWidth: .infinity)
            tabItem(image: "User", title: "마이페이지", tab: .myPage)
                .frame(maxWidth: .infinity)
        }
        .frame(height: 70)
        .padding(.horizontal, 16)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 8, y: -2)
    }
    
    private func tabItem(image: String, title: String, tab: Tab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(image)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(selectedTab == tab ? .black : .gray)
                Text(title)
                    .regular12()
                    .foregroundColor(selectedTab == tab ? .black : .gray)
            }
        }
    }
}
