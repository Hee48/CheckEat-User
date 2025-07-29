//
//  ErrorPage.swift
//  CheckEat-User
//
//  Created by Hee  on 7/25/25.
//

import SwiftUI

struct ErrorPage:View {
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Spacer()
                    Button {
//                        dismiss()
                    } label: {
                        Image("xmark")
                    } 
                    .padding(.trailing, 15)
                }
            }
            .frame(height: 44)
            Spacer()
            
            Image("ExclamationMark")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundStyle(.green)
                .padding(.bottom)
            
            Text("영수증 인식에\n실패했습니다.")
                .lineSpacing(4)
                .multilineTextAlignment(.center)
                .bold20()
            Text("밝은 곳에서 가까이 다시 촬영해 주세요.")
                .padding(.top, 20)
                .regular16()
            Spacer()
            
            Button {
            } label: {
                Text("다시 촬영")
                    .primaryButtonStyle()
                    .semibold16()
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            //            .fullScreenCover(isPresented: $) {
            //                재촬영뷰로 이동시키기
            //            }
        }
        .ignoresSafeArea(.keyboard)
    }
}
//#Preview {
//    ErrorPage()
//}
