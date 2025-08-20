//
//  ReviewCreated.swift
//  CheckEat-User
//
//  Created by Hee  on 7/28/25.
//

import SwiftUI
import Kingfisher

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
                                KFImage(url)
                                    .placeholder {
                                        ZStack {
                                            Rectangle().fill(Color("Button_OP20"))
                                            Image(systemName: "camera.fill")
                                                .resizable()
                                                .frame(width: 40, height: 30)
                                                .scaledToFit()
                                                .foregroundColor(.white)
                                                .padding(20)
                                        }
                                    }
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
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
                                    Text("label_recommend_target")
                                        .foregroundColor(.buttonOP20)
                                        .medium12()
                                  Text(LocalizedStringKey(VeganLevel(rawValue: review.revi_reco_vegan)?.description ?? "not_vegan"))
                                        .medium12()
                                }
                                .padding(.top, 20)
                                HStack {
                                    Image(systemName: "star.circle.fill")
                                        .foregroundColor(.buttonOP20)
                                    Text("label_recommend")
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
            .navigationTitle("section_written_reviews")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchReviewedStores()
            }
        }
    }
    
    func recommendText(for step: Int) -> LocalizedStringKey {
        switch step {
        case 0: return "review_recommend_yes"
        case 1: return "review_recommend_neutral"
        case 2: return "review_recommend_no"
        default: return ""
        }
    }
}
