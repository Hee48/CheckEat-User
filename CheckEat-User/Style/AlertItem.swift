//
//  Alert.swift
//  CheckEat-User
//
//  Created by Hee  on 7/20/25.
//
import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let dissmissButton: Alert.Button
}
