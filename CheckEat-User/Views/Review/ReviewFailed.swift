//
//  ReviewFailed.swift
//  CheckEat-User
//
//  Created by Hee  on 8/5/25.
//

import SwiftUI

struct ReviewFailed: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showCheckModal: Bool
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image("xmark")
                    }
                    .padding(.trailing, 15)
                }
            }
            .frame(height: 44)
            Spacer()
            
            Image("ExclamationMark")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundStyle(.green)
                .padding(.bottom)
            
            Text("review_failed_title".localized)
                .lineSpacing(4)
                .multilineTextAlignment(.center)
                .bold20()
            Text("review_failed_message".localized)
                .padding(.top, 20)
                .regular16()
            Spacer()
            
            Button {
                showCheckModal = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        dismiss()
                    }
            } label: {
                Text("common_close".localized)
                    .primaryButtonStyle()
                    .semibold16()
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .ignoresSafeArea(.keyboard)
    }
}
//#Preview {
//    ReviewFailed()
//}
