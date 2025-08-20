//
//  ReviewStopModal.swift
//  CheckEat-User
//
//  Created by Hee  on 7/26/25.
//

import SwiftUI

struct ReviewStopModal: View {
    @Environment(\.dismiss) private var dismiss
    var onClose: () -> Void
    var body: some View {
        VStack(alignment: .center) {
            Image("ExclamationMark")
            Text("review_stop_title".localized)
                .lineSpacing(6)
                .multilineTextAlignment(.center)
                .bold20()
                .padding(.top, 20)
            Text("review_stop_message".localized)
                .lineSpacing(6)
                .multilineTextAlignment(.center)
                .foregroundColor(.buttonOP50)
                .padding(.top, 20)
                .regular16()
            HStack(spacing: 1) {
                Button {
                    dismiss()
                } label: {
                    Text("common_close".localized)
                        .foregroundStyle(Color.buttonEnable)
                        .semibold16()
                        .frame(minWidth: 125)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .overlay(
                                 RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 0.3)
                             )
                }
                .padding()
                Button {
                    onClose()
                } label: {
                    Text("review_continue".localized)
                        .foregroundStyle(Color.white)
                        .semibold16()
                        .frame(minWidth: 125)
                        .padding()
                        .background(Color.buttonEnable)
                        .cornerRadius(5)
                    
                }
                .padding(.trailing)
            }
        }
        
        .padding()
        .frame(width: 362, height: 346)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
//#Preview {
//    ReviewStopModal(onClose: {})
//}
