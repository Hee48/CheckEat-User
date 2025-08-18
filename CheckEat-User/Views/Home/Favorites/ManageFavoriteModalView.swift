//
//  ManageFavoriteModalView.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/12/25.
//

import SwiftUI
import Combine

struct ManageFavoriteModalView: View {
    
    // NearByStoresModalView 스타일과 동일: 모달 표시 상태를 바인딩으로 제어
    @Binding var isPresented: Bool
    
    @StateObject private var viewModel = ManageFavoriteModalViewModel()
    @State private var selectedStoreId: Int? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
//                Text("⭐️ 즐겨찾기한 가게 (\(viewModel.items.count)곳)")
                Text("⭐️ 즐겨찾기한 가게")
                Spacer()
                Button("닫기") {
                    isPresented = false
                }
                .regular14()
                .foregroundStyle(.secondary)
            }
            .semibold18()
            .padding(.horizontal)
            .padding(.top, 24)
            .padding(.bottom, 4)
            
            // Content
            if viewModel.isLoading {
                ProgressView("불러오는 중…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let msg = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(.orange)
                    Text(msg)
                        .regular16()
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else {
                List(viewModel.items, id: \.sto_id) { item in
                    Button {
                        // 선택한 가게 아이디 저장
                        selectedStoreId = item.sto_id
                    } label: {
                        favoriteCell(for: item)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .background(Color.clear)
            }
        }
        .frame(maxHeight: .infinity)
        .onAppear {
            viewModel.load()
        }
        .sheet(item: $selectedStoreId) { id in
            StoreDetailInfoView(storeId: id, language: "ko")
                .presentationDetents([.large])
        }
    }
}

extension ManageFavoriteModalView {
    @ViewBuilder
    private func favoriteCell(for item: FavoriteStoreItem) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: item.sto_img ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 100)
                    .cornerRadius(8)
            } placeholder: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.buttonSoft)
                    Image(systemName: "storefront.fill")
                        .foregroundStyle(.buttonEnable)
                }
            }
            
            Text(item.sto_name)
                .bold20()
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image("Location")
                    Text(item.sto_address)
                }
                HStack {
                    Image("Time")
                    if let runtime = item.today_runtime {
                        Text("영업시간 \(runtime)")
                    } else {
                        Text("영업시간 정보 없음")
                    }
                }
                HStack {
                    Image("Time")
                    let breakTime = item.holi_break
                    let currentWeekday = item.today_weekday
                    Text("휴게시간 \(BreakTimeUtils.getBreakTimeText(for: item.holi_break, weekday: item.today_weekday))")
                }
            }
            .regular14()
            .foregroundColor(.secondary)
            .regular14()
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.white))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

// MARK: - ViewModel (기존과 동일)
class ManageFavoriteModalViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var items: [FavoriteStoreItem] = []

    private var bag = Set<AnyCancellable>()
    private let service = ManageFavoriteService()

    func load() {
        errorMessage = nil
        isLoading = true

        service.fetchFavoriteStoreItems()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.errorMessage = "즐겨찾기 목록을 가져오지 못했어요. 잠시 후 다시 시도해주세요.\n\(error.localizedDescription)"
                }
            } receiveValue: { [weak self] items in
                self?.items = items
            }
            .store(in: &bag)
    }
}


