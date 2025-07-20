//
//  OffDayButton.swift
//  CheckEat-Business
//
//  Created by Hee  on 7/17/25.
//

import SwiftUI

enum ButtonPosition {
    case left, middle, right
}

struct OffDayButton55: View {
    let offDay: String
    let isSelected: Bool
    let position: ButtonPosition
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(offDay)
                .font(.system(size: 14))
                .foregroundColor(isSelected ? .white : .black)
                .frame(width: 55, height: 48)
                .background(
                    RoundedCorner(radius: 5, corners: corner(for: position))
                        .fill(isSelected ? Color.black : Color.buttonOP)
                )
                .overlay(
                    RoundedCorner(radius: 5, corners: corner(for: position))
                        .stroke(Color.gray, lineWidth: 0.5)
                )
            
            
        }
        .buttonStyle(.plain)
    }
    
    private func corner(for position: ButtonPosition) -> UIRectCorner {
        switch position {
        case .left:
            return [.topLeft, .bottomLeft]
        case .middle:
            return []
        case .right:
            return [.topRight, .bottomRight]
        }
    }
}


struct OffDayButton67: View {
    let offDay: String
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(offDay)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .black)
                .frame(width: 67, height: 48)
                .background(RoundedRectangle(cornerRadius: 5)
                    .fill(isSelected ? Color.black : Color(Color.buttonOP)))
                .overlay(RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 0.5))
        }
        .buttonStyle(.plain)
    }
}

struct OffDayButton79: View {
    let offDay: String
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(offDay)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .black)
                .frame(width: 79, height: 48)
                .background(RoundedRectangle(cornerRadius: 5)
                    .fill(isSelected ? Color.black : Color(Color.buttonOP)))
                .overlay(RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 0.5))
        }
        .buttonStyle(.plain)
    }
}

struct OffDayButton83: View {
    let offDay: String
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(offDay)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .black)
                .frame(width: 83, height: 48)
                .background(RoundedRectangle(cornerRadius: 5)
                    .fill(isSelected ? Color.black : Color(Color.buttonOP)))
                .overlay(RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 0.5))
        }
        .buttonStyle(.plain)
    }
}

struct OffDayButton110: View {
    let offDay: String
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(offDay)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .black)
                .frame(width: 110, height: 48)
                .background(RoundedRectangle(cornerRadius: 5)
                    .fill(isSelected ? Color.black : Color(Color.buttonOP)))
                .overlay(RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 0.5))
        }
        .buttonStyle(.plain)
    }
}

