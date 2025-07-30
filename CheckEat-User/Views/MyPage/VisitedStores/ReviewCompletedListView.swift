//
//  ReviewCompletedListView.swift
//  CheckEat-User
//
//  Created by Hee  on 7/27/25.
//

import SwiftUI

struct ReviewCompletedListView: View {
    let dummyReviews = [
        (   menuImage: "testImage",
            menuName: "짜장면, 짬뽕, 탕수육",
            storeName: "홍콩반점",
            storeAddress: "서울 은평구 통일로 66길 10-16 2층"
        ),
        (   menuImage: "testImage",
            menuName: "고기짬뽕",
            storeName: "똥글뱅이",
            storeAddress: "서울 은평구 통일로 66길 10-16 2층"
        ),
        (   menuImage: "testImage",
            menuName: "콩콩콩",
            storeName: "게시고무",
            storeAddress: "서울 은평구 통일로 66길 10-16 2층"
        )
    ]

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
                            Text(review.menuName)
                                .bold18()
                            HStack {
                                Image("Location")
                                    .padding(.top, 20)
                                Text(review.storeAddress)
                                    .regular14()
                                    .padding(.top, 20)
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
    }
}

#Preview {
    ReviewCompletedListView()
}
