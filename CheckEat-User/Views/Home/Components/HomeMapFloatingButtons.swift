//
//  HomeMapFloatingButtons.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/29/25.
//

import SwiftUI

struct HomeMapFloatingButtons: View {
    var onNearbyTapped: () -> Void
    var onFavoriteTapped: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack(spacing: 20) {
                    Button(action: onFavoriteTapped) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(.buttonOP70)
                            .padding(17)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                    Button(action: onNearbyTapped) {
                        Image(systemName: "list.bullet")
                            .font(.system(size: 18))
                            .foregroundStyle(.buttonOP70)
                            .padding(20)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                }
                .padding(.trailing, 10)
                .padding(.bottom, 80)
            }
        }
    }
}
