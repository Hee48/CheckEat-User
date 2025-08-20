//
//  Alert.swift
//  CheckEat-User
//
//  Created by Hee  on 7/20/25.
//
import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: LocalizedStringKey
    let message: LocalizedStringKey
    let dissmissButton: Alert.Button
}
