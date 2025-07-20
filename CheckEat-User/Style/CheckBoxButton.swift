//
//  CheckBoxButton.swift
//  CheckEat-Business
//
//  Created by Hee  on 7/8/25.
//
import SwiftUI

struct CheckBoxButton: View {
    @Binding var isChecked: Bool
    var onToggle: (() -> Void)? = nil
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.1)) {
                isChecked.toggle()
                onToggle?()
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 3)
                    .fill(!isChecked ? Color.white : Color("Button_Enable"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(!isChecked ? Color("Button_OP20") : Color("Button_Enable") , lineWidth: 1)
                    )
                    .frame(width: 20, height: 20)
                
                Image(systemName: "checkmark")
                    .foregroundColor(!isChecked ? Color("Button_OP20") : Color.white )
                    .font(.system(size: 14, weight: .semibold))
                
            }
        }
    }
}
 
struct CheckBoxButtonBlack: View {
    @Binding var isChecked: Bool
    var onToggle: (() -> Void)? = nil
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.1)) {
                isChecked.toggle()
                onToggle?()
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 3)
                    .fill(!isChecked ? Color.white : Color.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(!isChecked ? Color.buttonOP70 : Color.white , lineWidth: 0.5)
                    )
                    .frame(width: 20, height: 20)
                if isChecked {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color.white)
                        .font(.system(size: 14, weight: .semibold))
                }
            }
        }
    }
}
