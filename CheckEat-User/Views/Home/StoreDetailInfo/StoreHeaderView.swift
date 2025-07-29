//
//  StoreHeaderView.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/29/25.
//

import SwiftUI

struct StoreHeaderView: View {
    let store: Store
    @EnvironmentObject var viewModel: StoreMapViewModel
    
    var body: some View {
        HStack {
            Text(store.sto_name)
                .bold20()
            Spacer()
            Button {
                viewModel.toggleFavorite(for: store)
            } label: {
                Image(systemName: viewModel.isFavorite(store: store) ? "star.fill" : "star")
                    .foregroundStyle(viewModel.isFavorite(store: store) ? .buttonEnable : .buttonOP50 )
            }
        }
    }
}
