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
            storeName: "홍콩반점",
            veganType: "비건",
            recommendation: "추천 하고 싶어요",
        ),
        (   menuImage: "testImage",
            storeName: "똥글뱅이",
            veganType: "비건아님",
            recommendation: "별 생각 없어요",
        ),
        (   menuImage: "testImage",
            storeName: "게시고무",
            veganType: "오보",
            recommendation: "추천 하고 싶지 않아요",
        )
    ]

    @Environment(\.dismiss) private var dismiss
    var body: some View {
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
                                HStack {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .foregroundColor(.buttonOP20)
                                    Text("추천대상")
                                        .foregroundColor(.buttonOP20)
                                        .medium12()
                                    Text(review.veganType)
                                        .medium12()
                                }
                                .padding(.top, 20)
                                HStack {
                                    Image(systemName: "star.circle.fill")
                                        .foregroundColor(.buttonOP20)
                                    Text("추천")
                                        .foregroundColor(.buttonOP20)
                                        .medium12()
                                    Text(review.recommendation)
                                        .medium12()
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
            .padding(.top, 20)
            .navigationTitle("작성한 리뷰")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
#Preview {
    ReviewCreated()
}
