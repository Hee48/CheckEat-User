//
//  VeganDropDown.swift
//  CheckEat-User
//
//  Created by Hee  on 7/24/25.
//
import SwiftUI


struct VeganDropDown: View {
    @Binding var selected: VeganLevel
    @State private var showOptions = false
    
    let options: [VeganLevel] = VeganLevel.allCases
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("vegan_category")
                .semibold14()
                .padding(.leading, 17)
            Button {
                withAnimation {
                    showOptions.toggle()
                }
            } label: {
                HStack {
                    Text(LocalizedStringKey(selected.description.isEmpty ? "not_applicable" : selected.description))
                        .regular14()
                        .foregroundColor(selected == .none ? .gray : .black)
                    Spacer()
                    Image("downMark")
                        .rotationEffect(.degrees(showOptions ? 180 : 0))
                        .foregroundColor(.black)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: 1))
            }
            .padding(.top, 10)
            .padding(.horizontal, 17)
            
            if showOptions {
                VStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button {
                            selected = option
                            withAnimation {
                                showOptions = false
                            }
                        } label: {
                            HStack {
                                Text(LocalizedStringKey(option.description))
                                    .regular14()
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                        }
                        Divider()
                    }
                }
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 0.5))
                .padding(.horizontal, 17)
            }
        }
    }
}
//#Preview {
//    VeganDropDown(selected: <#Binding<String>#>)
//}
