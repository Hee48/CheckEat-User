//
//  ReviewCreated.swift
//  CheckEat-User
//
//  Created by Hee  on 7/28/25.
//

import SwiftUI

struct ReviewCreated:View {
    let dummyReviews = [
        (   menuImage: "testImage",
            menuName: "짜장면, 짬뽕, 탕수육",
            storeName: "홍콩반점",
            veganType: "비건",
            recommendation: "추천 하고 싶어요",
            comment: "전부 콩으로만든 비건 음식이였습니다."
        ),
        (   menuImage: "testImage",
            menuName: "고기짬뽕",
            storeName: "똥글뱅이",
            veganType: "비건아님",
            recommendation: "별 생각 없어요",
            comment: ""
        ),
        (   menuImage: "testImage",
            menuName: "콩콩콩",
            storeName: "게시고무",
            veganType: "오보",
            recommendation: "추천 하고 싶지 않아요",
            comment: "고무맛이 너무났어요"
        )
    ]

    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(dummyReviews.indices, id: \.self) { index in
                        let review = dummyReviews[index]
                        HStack(alignment: .top, spacing: 12) {
                            Image(review.menuImage)
                                .frame(width: 95, height: 95)
                            VStack(alignment: .leading, spacing: 6) {
                                Text(review.storeName)
                                    .bold20()
                                Text(review.menuName)
                                    .bold18()
                                HStack {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .foregroundColor(.buttonOP20)
                                    Text("추천대상")
                                        .foregroundColor(.buttonOP20)
                                        .medium12()
                                    Text(review.veganType)
                                        .medium12()
                                }
                                HStack {
                                    Image(systemName: "star.circle.fill")
                                        .foregroundColor(.buttonOP20)
                                    Text("추천")
                                        .foregroundColor(.buttonOP20)
                                        .medium12()
                                    Text(review.recommendation)
                                        .medium12()
                                }
                                HStack(spacing: 6) {
                                    Image(systemName: "bubble.fill")
                                        .foregroundColor(.buttonOP20)
                                    Text("평가")
                                        .medium12()
                                        .foregroundColor(.buttonOP20)
                                    if review.comment.isEmpty {
                                        Text("코멘트가 작성되지 않았습니다.")
                                            .medium12()
                                            .foregroundColor(.buttonOP20)
                                    } else {
                                        Text(review.comment)
                                            .medium12()
                                    }
                                }
                            }

                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal)

                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 1)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                    }
                }
            }
            .navigationTitle("작성한 리뷰")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(.black)
                    }
                }
            }
        }
    }
} 
#Preview {
    ReviewCreated()
}
