//
//  UserImageChange.swift
//  CheckEat-User
//
//  Created by Hee  on 8/10/25.
//
import SwiftUI

struct UserImageChange: View {

    @Binding var selectedImageName: String
    @Environment(\.dismiss) private var dismiss

    private let candidates = ["user1".localized,"user2".localized,"user3".localized,"user4".localized,"user5".localized,"user6".localized]
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        VStack(spacing: 20) {
            Text("user_image_select_title".localized)
                .bold18()
                .padding(.top, 30)

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(candidates, id: \.self) { name in
                    Button {
                        selectedImageName = name
                        dismiss()
                    } label: {
                        ZStack {
                            Image(name)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 90, height: 90)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)

            Spacer(minLength: 8)

            Button {
                dismiss()
            } label: {
                Text("dialog_withdraw_cancel".localized)
                    .primaryButtonStyle(isEnabled: true)
                    .semibold16()
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 12)
        }
    }
}


