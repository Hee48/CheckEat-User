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
    @State private var selectedTab: Tab = .home
    @StateObject private var authViewModel = AuthViewModel.shared
    @State private var reviewPath: [ReviewPath] = []
    @State private var isReviewFlowActive: Bool = false
    @State private var showCheckModal: Bool = false
    @State private var storeName: String = ""
    @State private var storeAddress: String = ""
    @State private var showOCRView: Bool = true 
    @State private var isPresented: Bool = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                VStack {
                    ZStack {
                        switch selectedTab {
                        case .home:
                            HomeMapView()
                        case .review:
                            NavigationStack(path: $reviewPath) {
                                OCRView(isReviewFlowActive: $isReviewFlowActive, reviewPath: $reviewPath)
                                    .navigationDestination(for: ReviewPath.self) { path in
                                        switch path {
                                        case .checkModal:
                                            CheckModal(
                                                showCheckModal: $showCheckModal,
                                                storeName: $storeName,
                                                storeAddress: $storeAddress,
                                                showOCRView: $showOCRView,
                                                reviewPath: $reviewPath,
                                                isReviewFlowActive: $isReviewFlowActive,
                                                isPresented: $isPresented
                                            )
                                        case .reviewQuestionView(let storeId):
                                            ReviewQuestionView(
                                                storeId: storeId,
                                                showCheckModal: $showCheckModal,
                                                isPresented: $isPresented,
                                                reviewPath: $reviewPath,
                                                isReviewFlowActive: $isReviewFlowActive
                                            )
                                        case .addReivewView(let storeId):
                                            AddReivewView(
                                                isPresented: $isPresented,
                                                showCheckModal: $showCheckModal,
                                                reviewPath: $reviewPath,
                                                isReviewFlowActive: $isReviewFlowActive,
                                                storeId: storeId
                                            )
                                        }
                                    }
                            }
                        case .myPage:
                            MyPageView(selectedTab: $selectedTab)
                        }
                    }
                    .frame(maxHeight: .infinity)
                    
                    CustomTabBarView(
                        selectedTab: $selectedTab,
                        reviewPath: reviewPath,
                        isReviewFlowActive: isReviewFlowActive
                    )
                }
                .background(Color.white)
            }
            .environmentObject(authViewModel)
        }
    }
}
