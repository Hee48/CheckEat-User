//
//  NearbyStoreModalView.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/22/25.
//

import SwiftUI
import CoreLocation

struct NearbyStoreModalView: View {
    @Binding var isPresented: Bool
    var currentLocation: CLLocationCoordinate2D
    var stores: [Store]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("🔍 1Km 반경 가게 (\(stores.count)곳 조회)")
                    .regular16()
                Spacer()
                Button("닫기") {
                    isPresented = false
                }
                .regular14()
            }
            .padding()

            List(stores, id: \.storeId) { store in
                HStack(spacing: 8) {
                    AsyncImage(url: URL(string: store.sto_img!)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipped()
                            .cornerRadius(8)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 60, height: 60)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(store.sto_name)
                            .bold20()
                        Group {
                            Text("주소 | \(store.sto_address)")
                            Text("위치 | 위도 \(store.sto_latitude), 경도 \(store.sto_longitude)")
                        }
                        .regular14()
                        .foregroundColor(.secondary)
                            
                    }
                }
            }
            .listStyle(.plain)
        }
        .frame(maxHeight: .infinity)
    }
}
