//
//  CheckEat_UserApp.swift
//  CheckEat-User
//
//  Created by Hee  on 7/3/25.
//

import SwiftUI
import GoogleMaps

@main
struct CheckEat_UserApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var selectedTab: CustomTabBarView.Tab = .home
    
    var body: some Scene {
        WindowGroup {
            VStack {
                ZStack {
                    switch selectedTab {
                    case .home:
                        HomeMapView()
                    case .review:
                        ReviewQuestionView()
                    case .myPage:
                        MyPageView()
                    }
                }
                .frame(maxHeight: .infinity)

                CustomTabBarView(selectedTab: $selectedTab)
            }
            .background(Color.white)
        }
    }
}
