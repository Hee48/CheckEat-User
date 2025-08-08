//
//  LoginFlowRootView.swift
//  CheckEat-User
//
//  Created by Hee  on 8/7/25.
//
import SwiftUI

enum LoginFlowRoute: Hashable {
    case join
    case joinComplete
}

//struct LoginFlowRootView: View {
//    @State private var path = NavigationPath()
//    
//    var body: some View {
//        NavigationStack(path: $path) {
//            LoginView(path: $path)
//                .navigationDestination(for: LoginFlowRoute.self) { route in
//                    switch route {
//                    case .join:
//                        JoinView(path: $path)
//                    case .joinComplete:
//                        UserRegistrationComplete(path: $path)
//                    }
//                }
//        }
//    }
//}
