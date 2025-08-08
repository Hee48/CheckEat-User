//
//  ReviewCompletedListView.swift
//  CheckEat-User
//
//  Created by Hee  on 7/27/25.
//

import SwiftUI

struct ReviewCompletedListView: View {
    @ObservedObject var viewModel: VisitedStoreViewModel
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if viewModel.myReviews.isEmpty {
                    Text("리뷰가 없습니다.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(viewModel.myReviews, id: \.revi_id) { review in
                        HStack(alignment: .top, spacing: 12) {
                            if let imageUrlString = review.images.first,
                               let url = URL(string: imageUrlString) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Rectangle().foregroundColor(.gray.opacity(0.2))
                                }
                                .frame(width: 95, height: 95)
                                .cornerRadius(10)
                                .clipped()
                            } else {
                                ZStack {
                                    Rectangle()
                                        .fill(Color("Button_OP20"))
                                    Image(systemName: "camera.fill")
                                        .resizable()
                                        .frame(width: 40, height: 30)
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .padding(20)
                                }
                                .frame(width: 95, height: 95)
                                .cornerRadius(10)
                            }
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(review.store.sto_name)
                                    .bold20()
                                HStack {
                                    Image(systemName: "star.circle.fill")
                                        .foregroundColor(.buttonOP20)
                                    Text("추천")
                                        .foregroundColor(.buttonOP20)
                                        .medium12()
                                    Text(recommendText(for: review.revi_reco_step))
                                        .medium12()
                                }
                                .padding(.top, 20)
                                HStack(spacing: 6) {
                                    Image(systemName: "bubble.fill")
                                        .foregroundColor(.buttonOP20)
                                    Text("평가")
                                        .medium12()
                                        .foregroundColor(.buttonOP20)
                                    if (review.revi_content ?? "").isEmpty {
                                        Text("코멘트가 작성되지 않았습니다.")
                                            .medium12()
                                            .foregroundColor(.buttonOP20)
                                    } else {
                                        Text(review.revi_content ?? "")
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
        }
        .onAppear {
            viewModel.fetchReviewedStores()
        }
    }
    
    func recommendText(for step: Int) -> String {
        switch step {
        case 0: return "추천 하고 싶어요"
        case 1: return "별 생각 없어요"
        case 2: return "추천 하고 싶지 않아요"
        default: return ""
        }
    }
}

//#Preview {
//    ReviewCompletedListView()
//}
