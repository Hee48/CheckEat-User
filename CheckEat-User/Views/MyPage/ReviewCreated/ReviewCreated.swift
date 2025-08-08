//
//  ReviewCreated.swift
//  CheckEat-User
//
//  Created by Hee  on 7/28/25.
//

import SwiftUI

struct ReviewCreated:View {

    @ObservedObject var viewModel: VisitedStoreViewModel
    @Environment(\.dismiss) private var dismiss
    var body: some View {
            ScrollView {
                VStack(spacing: 0) {
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
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .foregroundColor(.buttonOP20)
                                    Text("추천대상")
                                        .foregroundColor(.buttonOP20)
                                        .medium12()
                                    Text(VeganLevel(rawValue: review.revi_reco_vegan)?.description ?? "비건 아님")
                                        .medium12()
                                }
                                .padding(.top, 20)
                                HStack {
                                    Image(systemName: "star.circle.fill")
                                        .foregroundColor(.buttonOP20)
                                    Text("추천")
                                        .foregroundColor(.buttonOP20)
                                        .medium12()
                                    Text(recommendText(for: review.revi_reco_step))
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
            .onAppear {
                viewModel.fetchReviewedStores()
            }
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
