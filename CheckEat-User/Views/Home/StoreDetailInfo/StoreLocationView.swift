//
//  StoreLocationView.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/29/25.
//

import SwiftUI

struct StoreLocationView: View {
    let store: Store
    @Binding var isFieldVisible: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image("Location")
                Text(store.sto_address)
                Spacer()
                Button {
                    isFieldVisible.toggle()
                } label: {
                    Image(systemName: isFieldVisible ? "chevron.up" : "chevron.down")
                        .resizable()
                        .frame(width: 12, height: 8)
                        .foregroundStyle(.buttonOP50)
                }
            }
            .padding(.trailing, 4)
            
            if isFieldVisible {
                HStack(spacing: 4) {
                    Image("Desc")
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.buttonEnable)
                    Text("\(store.sto_latitude)(latitude), \(store.sto_longitude)(longtitude)")
                }
                .medium16()
                .foregroundStyle(.buttonEnable)
                .padding(.vertical, 2)
            }
        }
    }
}
