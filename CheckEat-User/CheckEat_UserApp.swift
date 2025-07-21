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
    
    var body: some Scene {
        WindowGroup {
            HomeMapView()
        }
    }
}
