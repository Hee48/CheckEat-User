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
        
        return true
    }
}

