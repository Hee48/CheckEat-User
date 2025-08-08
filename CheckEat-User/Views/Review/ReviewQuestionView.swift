//
//  Review.swift
//  CheckEat-User
//
//  Created by Hee  on 7/26/25.
//

import SwiftUI

struct ReviewQuestionView:View {
 
    @Environment(\.dismiss) private var dismiss
    let storeId: Int
//    @State private var showReviewPage = false
    @Binding var showCheckModal: Bool
    @StateObject private var viewModel = ReviewViewModel()
    @Binding var isPresented: Bool
    @Binding var reviewPath: [ReviewPath]
    @Binding var isReviewFlowActive: Bool
    var body: some View {
        VStack {
            Spacer()
            
            Image("QuestionMark")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundStyle(.green)
                .padding(.bottom)
            
            Text("바로 리뷰를\n등록하시겠어요?")
                .lineSpacing(4)
                .multilineTextAlignment(.center)
                .bold20()

            Spacer()
            
            HStack(spacing: 12) {
                Button {
                    viewModel.registLaterReview(storeId: storeId)
                    showCheckModal = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            dismiss()
                        }
                } label: {
                    Text("다음에등록")
                        .foregroundStyle(Color.buttonEnable)
                        .semibold16()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 0.3)
                        )
                }
                Button {
                    reviewPath.append(.addReivewView(storeId: storeId))
                } label: {
                    Text("리뷰등록")
                        .foregroundStyle(Color.white)
                        .semibold16()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.buttonEnable)
                        .cornerRadius(5)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.registerSuccess) { success in
            if success {
                DispatchQueue.main.async {
                    showCheckModal = false
                    dismiss()
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
    
}
