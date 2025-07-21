//
//  HomeMapView.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/21/25.
//

import SwiftUI

struct HomeMapView: View {
    
    @StateObject private var locationManager = LocationManager()
    @State private var searchText:String = ""
    @State private var selectedFilter: String = "마이필터"

    var body: some View {
        ZStack {
            GoogleMapView(coordinate: $locationManager.userLocation)
                .ignoresSafeArea()

            VStack {
                Spacer()
                if locationManager.userLocation == nil {
                    HStack(spacing: 8) {
                        ProgressView()
                        Text("위치 가져오는 중...")
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .overlay(
            VStack(spacing: 16) {
                SearchBar(text: $searchText, placeholder: " 찾으시려는 장소를 검색해보세요")
                FilterButton(selectedFilter: $selectedFilter)
            }
            .padding(.horizontal)
            .padding(.top, 35),
            alignment: .top
        )
    }
}

#Preview {
    HomeMapView()
}
