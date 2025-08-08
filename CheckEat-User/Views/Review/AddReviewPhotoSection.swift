//
//  AddReviewPhotoSection.swift
//  CheckEat-User
//
//  Created by Hee  on 7/26/25.
//

import SwiftUI

struct AddReviewPhotoSection: View {
    @Binding var images: [UIImage]
    var onAdd: () -> Void
    var onDelete: (Int) -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            // 카메라 버튼
            Button(action: onAdd) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        .frame(width: 80, height: 80)
                    VStack(spacing: 4) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                            .frame(width: 40, height: 40)
                        Text("\(images.count) / 4")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: 80, height: 90)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(images.indices, id: \.self) { index in
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: images[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 10))

                            // 삭제 버튼
                            Button(action: {
                                onDelete(index)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.black)
                                    .background(Color.white.clipShape(Circle()))
                            }
                            .offset(x: 5, y: -5)
                            .zIndex(1)
                        }
                        .frame(width: 80, height: 90)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
        
}
