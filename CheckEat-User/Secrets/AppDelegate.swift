//
//  AppDelegate.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/20/25.
//

import UIKit
import GoogleMaps

//MARK: apiKey 확인 테스트
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        let mapApiKey = SecretManager.getValue(for: "GOOGLE_MAPS_API_KEY")
        GMSServices.provideAPIKey(mapApiKey)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        appearance.backButtonAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: -1000, vertical: 0)
        appearance.shadowColor = .clear
        
        // 백버튼 이미지 설정
        let backButtonImage = UIImage(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .black
        
        return true
    }
}
