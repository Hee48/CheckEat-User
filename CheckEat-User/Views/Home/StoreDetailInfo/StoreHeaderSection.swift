//
//  StoreHeaderSection.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/12/25.
//

import SwiftUI

struct StoreHeaderSection: View {
    
    let storeId: Int
    
    let storeInfo: StoreDetailInfo
    @EnvironmentObject var viewModel: StoreDetailInfoViewModel
    
    var body: some View {
        HStack(spacing: 8) {
            Text(storeInfo.sto_name)
                .bold20()
            Text(storeInfo.sto_name_en)
                .regular14()
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
        .regular16()
        .padding(.top, 24)
    }
}
