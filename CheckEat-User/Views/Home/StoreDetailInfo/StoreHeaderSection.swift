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
    
    @State private var currentLanguage = LanguageSettingsViewModel.getCurrentLanguage()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                if LanguageSettingsViewModel.getCurrentLanguage() == "ko" {
                    Text(storeInfo.sto_name)
                        .bold20()
                } else {
                    Text(storeInfo.sto_name_en)
                        .bold20()
                }
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
            if LanguageSettingsViewModel.getCurrentLanguage() == "ko" {
                Text(storeInfo.sto_name_en)
                    .regular16()
                    .foregroundStyle(.buttonOP50)
                    .padding(.bottom, 8)
            } else {
                Text(storeInfo.sto_name)
                    .regular16()
                    .foregroundStyle(.buttonOP50)
                    .padding(.bottom, 8)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LanguageChanged"))) { _ in
                    // 언어 변경시 실시간 업데이트
                    currentLanguage = LanguageSettingsViewModel.getCurrentLanguage()
                }
    }
}
