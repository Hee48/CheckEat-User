//
//  StoreDetailInfoView.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/11/25.
//

import SwiftUI

struct StoreDetailInfoView: View {

    // 목록에서 선택된 가게 ID와 사용자 설정 언어
    let storeId: Int
    let language: String

    @StateObject private var viewModel = StoreDetailInfoViewModel()

    // (임시) 아직 API가 제공하지 않는 정보들 — 추후 교체 예정
    @State private var today_runtime: String = "09:00 ~ 18:00"
    @State private var holi_break: String = "13:00 ~ 14:00"
    @State private var holi_regular: String = "매주 월요일"
    @State private var holi_public: String = "설날, 추석"

    var body: some View {
        GeometryReader { geo in
            Group {
                // 로딩 상태
                if viewModel.isLoading {
                    ProgressView("불러오는 중…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                // 에러 상태
                else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(errorMessage)
                            .regular16()
                            .multilineTextAlignment(.center)
                        Button("다시 시도") {
                            viewModel.loadStoreDetailInfo(storeId: storeId, language: language)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                }
                // 성공 상태 — 데이터 표시
                else if let d = viewModel.storeDetailInfo {
                    ScrollView {
                        VStack(spacing: 0) {
                            // 상단 이미지
                            ZStack {
                                Rectangle()
                                    .fill(Color(UIColor.systemGray5))
                                    .frame(maxWidth: .infinity, minHeight: geo.size.height * 0.3)
                                AsyncImage(url: URL(string: d.sto_img ?? "")) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geo.size.width, height: geo.size.height * 0.3)
                                        .clipped()
                                } placeholder: {
                                    Image(systemName: "storefront.fill")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .foregroundStyle(.secondary)
                                }
                            }

                            // 기본 정보
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(d.sto_name_en)
                                        .bold20()
                                    Spacer()
                                    Button {
                                        viewModel.toggleFavorite(storeId: storeId)
                                    } label: {
                                        if viewModel.isFavoriteLoading {
                                            ProgressView()
                                                .progressViewStyle(.circular)
                                                .frame(width: 20, height: 20)
                                        } else {
                                            Image(systemName: viewModel.isFavorite(storeId: storeId) ? "star.fill" : "star")
                                                .foregroundStyle(viewModel.isFavorite(storeId: storeId) ? .buttonEnable : .buttonOP50 )
                                        }
                                    }
                                }

                                HStack(spacing: 8) {
                                    Text(d.sto_type)
                                        .regular12()
                                        .foregroundStyle(.secondary)
                                    if d.sto_halal == 1 {
                                        Text("할랄 인증")
                                            .regular12()
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.green)
                                            .foregroundColor(.white)
                                            .cornerRadius(4)
                                    }
                                }

                                HStack(alignment: .top, spacing: 6) {
                                    Image("Location")
                                    Text(d.sto_address)
                                        .regular14()
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 24)

                            // 운영 정보 (임시)
                            VStack(alignment: .leading, spacing: 4) {
                                HStack { Image("Time"); Text("영업시간 \(today_runtime)") }
                                HStack { Image("Time"); Text("브레이크타임 \(holi_break)") }
                                HStack {
                                    Image("Calendar")
                                    Text("\(holi_regular) 정기 휴무 | \(holi_public) 휴무")
                                        .foregroundStyle(.red)
                                }
                            }
                            .regular14()
                            .padding(.horizontal)
                            .padding(.top, 12)

                            // Divider
                            Rectangle()
                                .fill(Color("Button_OP20"))
                                .frame(height: 1)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)

                            // 메뉴 섹션
                            VStack(alignment: .leading, spacing: 12) {
                                Text("메뉴")
                                    .bold()
                                ForEach(d.food_list) { m in
                                    HStack(alignment: .top) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(m.foo_name)
                                                .bold()
                                            if !m.foo_material.isEmpty {
                                                Text("알레르기: " + m.foo_material.joined(separator: ", "))
                                                    .regular12()
                                                    .foregroundStyle(.secondary)
                                            }
                                        }
                                        Spacer()
                                        Text(formatPrice(m.foo_price))
                                    }
                                    .padding(.vertical, 6)
                                    Divider()
                                }
                            }
                            .regular16()
                            .padding(.horizontal)
                            .padding(.bottom, 24)
                        }
                    }
                }
                // 초기 상태 안전망
                else {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .onAppear {
            if viewModel.storeDetailInfo == nil {
                viewModel.loadStoreDetailInfo(storeId: storeId, language: language)
            }
        }
    }

    private func formatPrice(_ s: String) -> String {
        if let n = Int(s) {
            let f = NumberFormatter(); f.numberStyle = .decimal
            return (f.string(from: n as NSNumber) ?? s) + "원"
        }
        return s
    }
}
