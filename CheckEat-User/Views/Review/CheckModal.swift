//
//  CheckModal.swift
//  CheckEat-User
//
//  Created by Hee  on 7/29/25.
//

import SwiftUI

struct CheckModal: View {
    let storeName: String
    let storeAddress: String
    @State private var showReviewQuestion = false
    var body: some View {
        VStack {
            Spacer()

            VStack(alignment: .center) {
                Text(storeName)
                    .bold20()
                Text(storeAddress)
                    .medium16()
                    .padding(.top, 20)
            }

            Spacer()

            HStack {
                Button {
                    //재스캔 시키기
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
                   showReviewQuestion = true
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
        .fullScreenCover(isPresented: $showReviewQuestion, content: {
            ReviewQuestionView()
        })
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
#Preview {
    CheckModal(storeName: "슈의 초밥가게", storeAddress: "서울특별시 강남구 테헤란로 1~19")
}
