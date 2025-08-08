//
//  FindHeaderView.swift
//  CheckEat-Business
//
//  Created by 최준영 on 8/6/25.
//

import SwiftUI

struct FindHeaderView: View {
    
    var title: String
    var subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .bold20()
                .padding(.top, 24)
                .padding(.bottom, 4)
            
            Text(subtitle)
                .regular16()
                .padding(.bottom, 35)
        }
    }
}
