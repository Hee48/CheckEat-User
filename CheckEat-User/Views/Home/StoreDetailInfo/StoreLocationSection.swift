//
//  StoreLocationSection.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/17/25.
//

import SwiftUI

struct StoreLocationSection: View {
    
    let storeInfo: StoreDetailInfo
    @Binding var showLocationField: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            Image("Location")
            Text(storeInfo.sto_address)
            Spacer()
            Button {
                showLocationField.toggle()
            } label: {
                Image(systemName: showLocationField ? "chevron.up" : "chevron.down")
                    .resizable()
                    .frame(width: 12, height: 8)
                    .foregroundStyle(.buttonOP50)
            }
        }
        .regular16()
        .padding(.trailing, 4)
        
        if showLocationField {
            HStack(spacing: 4) {
                Image("Desc")
                    .frame(width: 16, height: 16)
                    .foregroundStyle(.buttonEnable)
                Text("\(storeInfo.sto_latitude)(latitude), \(storeInfo.sto_longitude)(longtitude)")
            }
            .medium14()
            .foregroundStyle(.buttonEnable)
            .padding(.vertical, 2)
        }
    }
}
