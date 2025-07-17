//
//  StepCircle.swift
//  CheckEat-Business
//
//  Created by Hee  on 7/10/25.
//

import SwiftUI

struct StepCircle: View {
    let number: Int
    let fillColor: Color
    let textColor: Color
    
    var body: some View {
            ZStack {
                Circle()
                    .fill(fillColor)
                    .frame(width: 20, height: 20)
                Text("\(number)")
                    .foregroundColor(textColor)
                    .font(.system(size: 14, weight: .semibold))
            }
            .padding(.top, 20)
    }
}

