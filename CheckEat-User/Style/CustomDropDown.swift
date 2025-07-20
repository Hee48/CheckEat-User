//
//  CustomDropDown.swift
//  CheckEat-Business
//
//  Created by Hee  on 7/15/25.
//

import SwiftUI

struct CustomDropdown: View {
    @Binding var selectionOption: String
    @Binding var isExpanded: Bool
    @Binding var dropdownPosition: CGPoint
    let options:[String]
    
    var body: some View {
        ZStack {
            Button {
                isExpanded.toggle()
            } label: {
                HStack {
                    Text(selectionOption)
                        .font(.system(size: 14))
                        .foregroundColor(.buttonOP70)
                    Image("downMark")
                        .padding(.leading, 5)
                }
                .padding(.horizontal, 12)
                .frame(width: 77, height: 48)
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 5)
                    .stroke(Color("Button_OP70"), lineWidth: 0.5))
            }
            
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        dropdownPosition = geometry.frame(in: .global).origin
                    }
                    .onChange(of: geometry.frame(in: .global)) { newFrame in
                        dropdownPosition = newFrame.origin
                    }
            }
        }
        .frame(width: 77, height: 48)
    }
    
}

struct DropdownOptionList: View {
    let options: [String]
    @Binding var selectionOption: String
    @Binding var isExpanded: Bool
    var position: CGPoint
    var dropdownSpacing: CGFloat
    var body: some View {
        if isExpanded {
            VStack(spacing: 0) {
                ForEach(options, id: \.self) { option in
                    Button {
                        selectionOption = option
                        isExpanded = false
                    } label: {
                        HStack {
                            Text(option)
                                .font(.system(size: 14))
                                .foregroundColor(selectionOption == option ? Color("Button_Enable") : Color("Button_OP70"))
                                .padding(.leading, 20)
                            Spacer()
                        }
                        .frame(width: 77, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(selectionOption == option ? Color("Button_OP") : Color.white)
                                .padding(.horizontal, 3)
                                .padding(.vertical, 3)
                        )
                    }
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.buttonOP70, lineWidth: 0.5)
            )
            .frame(width: 77)
            .position(
                x: position.x + 38.5,
                y: position.y + 40 + dropdownSpacing
            )
            
            .zIndex(1000)
        }
    }
}
