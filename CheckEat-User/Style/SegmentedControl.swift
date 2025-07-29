//
//  SegmentedControl.swift
//  CheckEat-Business
//
//  Created by Hee  on 7/21/25.
//

import SwiftUI

struct SegmentedControl: View {
    let segments: [String]
    @Binding var selectedIndex: Int
    @Namespace private var animationNamespace

    var body: some View {
        HStack(spacing: 0) {
            ForEach(segments.indices, id: \.self) { index in
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        selectedIndex = index
                    }
                } label: {
                    VStack(spacing: 4) {
                        Text(segments[index])
                            .fontWeight(selectedIndex == index ? .bold : .regular)
                            .foregroundColor(.black)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                        if selectedIndex == index {
                            Capsule()
                                .fill(Color.black)
                                .matchedGeometryEffect(id: "underline", in: animationNamespace)
                                .frame(height: 2)
                        } else {
                            Color.clear.frame(height: 2)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}
