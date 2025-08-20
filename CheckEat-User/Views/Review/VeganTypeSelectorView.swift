//
//  VeganTypeSelectorView.swift
//  CheckEat-User
//
//  Created by Hee  on 8/5/25.
//

import SwiftUI

struct VeganTypeSelectorView: View {
    @Binding var selectedType: VeganLevel
    @State private var showVeganModal = false
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text("review_recommend_question".localized)
                    .semibold14()
                Button {
                    showVeganModal = true
                } label: {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 16))
                        .foregroundColor(.buttonOP20)
                }
            }
            .padding(.top, 10)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 6) {
                    ForEach(VeganLevel.allCases) { type in
                        Button {
                            selectedType = type
                        } label: {
                            Text(LocalizedStringKey(type.description))
                                .medium14()
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(selectedType == type ? Color.black : Color.buttonOP20)
                                .foregroundColor(selectedType == type ? .white : .black)
                                .cornerRadius(20)
                        }
                    }
                }
            }
            .frame(height: 40)
            .padding(.top, 10)
        }
        .sheet(isPresented: $showVeganModal) {
            VeganModal()
                .presentationDetents([.height(450)])
        }
    }
}
