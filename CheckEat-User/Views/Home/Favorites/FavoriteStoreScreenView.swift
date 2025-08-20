//
//  FavoriteStoreScreenView.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/29/25.
//

import SwiftUI
import Combine

struct FavoriteStoreScreenView: View {
    @Binding var isPresented: Bool
    @Binding var selectedStoreId: Int?
    @StateObject private var vm = FavoriteStoreScreenViewModel()
    @State private var didLoad = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if vm.isLoading {
                    ProgressView("loading_message")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let msg = vm.errorMessage {
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
                } else if vm.items.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "star").font(.largeTitle).foregroundStyle(.secondary)
                        Text("empty_favorite_store").regular14()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ManagerFavoriteStoreListView(
                        selectedStoreId: $selectedStoreId,
                        items: vm.items
                    )
                }
            }
            .onAppear {
                if !didLoad {
                    didLoad = true
                    vm.load()
                }
            }
            .sheet(item: $selectedStoreId) { id in
                StoreDetailInfoView(storeId: id, language: "ko")
                    .presentationDetents([.large])
            }
            .navigationTitle("favorite_store_title")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

final class FavoriteStoreScreenViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: LocalizedStringKey? = nil
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
                    self.errorMessage = "favorite_store_error_message"
                }
            } receiveValue: { [weak self] items in
                self?.items = items
            }
            .store(in: &bag)
    }
}
