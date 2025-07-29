//
//  Review.swift
//  CheckEat-User
//
//  Created by Hee  on 7/26/25.
//

import SwiftUI

struct ReviewQuestionView:View {
    @Environment(\.dismiss) private var dismiss
    @State private var showReviewPage = false
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
            
            Image("QuestionMark")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundStyle(.green)
                .padding(.bottom)
            
            Text("바로 리뷰를\n등록하시겠어요?")
                .lineSpacing(4)
                .multilineTextAlignment(.center )
                .bold20()

            Spacer()
            
            HStack(spacing: 12) {
                Button {
                //ocr스캔정보가 마이페이지에 리뷰미등록부분에 데이터가 가야함
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
                    showReviewPage = true
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
            .fullScreenCover(isPresented: $showReviewPage) {
                AddReivewView()
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}
#Preview {
    ReviewQuestionView()
}
