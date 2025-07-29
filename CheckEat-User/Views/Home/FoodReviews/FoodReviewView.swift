//
//  FoodReviewView.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/27/25.
//

import SwiftUI

struct FoodReviewView: View {
    
    @ObservedObject var viewModel: FoodReviewViewModel
    let foodId: Int
    let stores: [Store]
    @State var foodName: String = ""
    @State private var storeName: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if foodId < 0 {
                    Text("⚠️ 유효하지 않은 메뉴 정보입니다.")
                    Text("리뷰를 불러올 수 없습니다. 다시 시도해 주세요.")
                } else {
                    let reviews = viewModel.reviews(for: foodId)
                    
                    if reviews.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("\(foodName) 리뷰")
                                .bold20()
                                .padding(.bottom)
                            HStack {
                                Spacer()
                                Text("등록된 리뷰가 없습니다.")
                                    .foregroundStyle(.secondary)
                                Spacer()
                            }
                            .padding(.vertical, 150)
                            //FIXME: 화면 크기에 따른 센터 정렬
                        }
                        .padding(.horizontal)
                    } else {
                        VStack {
                            HStack {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("\(foodName) 리뷰")
                                        .bold20()
                                        .padding(.bottom)
                                    ForEach(reviews) { review in
                                        FoodReviewRow(review: review)
                                        Divider()
                                    }
                                }
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top, -30)
            .onAppear {
                foodName = viewModel.foodName(for: foodId) ?? "(메뉴 불러오는 중)"
                storeName = viewModel.storeName(for: foodId, from: stores) ?? "(가게 정보 없음)"
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(storeName)
                        .foregroundStyle(.secondary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image("xmark")
                    }
                }
            }
        }
    }
}


struct FoodReviewRow: View {
    let review: Review
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 12) {
                AsyncImage(url: URL(string: review.revi_img ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 70)
                        .cornerRadius(8)
                } placeholder: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 70, height: 70)
                            .foregroundStyle(.buttonOP)
                        Image(systemName: "quote.opening")
                            .foregroundStyle(.buttonEnable)
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("리뷰어")
                        .bold20()
                        .padding(.bottom, 2)
                    switch review.revi_reco_step {
                    case 0 :
                        HStack(spacing: 4) {
                            Image(systemName: "star.circle.fill")
                            Text("추천")
                            Text("추천하고 싶어요")
                                .foregroundStyle(.buttonAuth)
                        }
                        .foregroundStyle(.buttonOP20)
                    case 1 :
                        HStack(spacing: 4) {
                            Image(systemName: "star.circle.fill")
                            Text("추천")
                            Text("별 생각 없어요")
                                .foregroundStyle(.buttonAuth)
                        }
                        .foregroundStyle(.buttonOP20)
                    case 2 :
                        HStack(spacing: 4) {
                            Image(systemName: "star.circle.fill")
                            Text("추천")
                            Text("추천하고 싶지 않아요")
                                .foregroundStyle(.buttonAuth)
                        }
                        .foregroundStyle(.buttonOP20)
                    default:
                        Text("로딩 중...")
                            .foregroundStyle(.buttonOP20)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.fill")
                        Text("평가")
                        if let content = review.revi_content, !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            Text(content)
                                .foregroundStyle(.buttonAuth)
                        } else {
                            Text("코멘트가 작성되지 않았습니다.")
                                .foregroundStyle(.buttonOP20) 
                        }
                    }
                    .foregroundStyle(.buttonOP20)
                }
                .regular14()
            }
        }
    }
}
