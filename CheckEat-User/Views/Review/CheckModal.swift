//
//  CheckModal.swift
//  CheckEat-User
//
//  Created by Hee  on 7/29/25.
//

import SwiftUI

struct CheckModal: View {
    @Binding var showCheckModal: Bool
    @Binding var storeName: String
    @Binding var storeAddress: String
    @Binding var showOCRView: Bool
    @State private var showReviewQuestion = false
    @State private var showReviewFailed = false
    @EnvironmentObject var viewModel: ReviewViewModel
    @Binding var reviewPath: [ReviewPath]
    @Binding var isReviewFlowActive: Bool
    @Binding var isPresented: Bool
    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .center) {
                Text("가게명 : \(storeName) ")
                    .bold20()
                Text("주소 : \(storeAddress) ")
                    .medium16()
                    .padding(.top, 20)
            }
            
            Spacer()
            
            HStack {
                Button {
                    showCheckModal = false
                    showOCRView = true
                } label: {
                    Text("다릅니다")
                        .foregroundStyle(Color.buttonEnable)
                        .semibold16()
                        .frame(minWidth: 130)
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
                    viewModel.checkCanWriteReview(storeName: storeName, storeAddress: storeAddress)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if viewModel.canWrite, let storeId = viewModel.storeId {
                            reviewPath.append(.reviewQuestionView(storeId: storeId))
                            isReviewFlowActive = true
                            showCheckModal = false
                        } else {
                            showReviewFailed = true
                        }
                    }
                } label: {
                    Text("맞습니다")
                        .foregroundStyle(Color.white)
                        .semibold16()
                        .frame(minWidth: 130)
                        .padding()
                        .background(Color.buttonEnable)
                        .cornerRadius(5)
                }
            }
            .padding(.bottom, 30)
        }
        .padding(.trailing, 15)

        .fullScreenCover(isPresented: $showReviewFailed) {
            ReviewFailed(showCheckModal: $showCheckModal)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
