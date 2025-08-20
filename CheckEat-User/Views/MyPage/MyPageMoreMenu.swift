//
//  MyPageMoreMenu.swift
//  CheckEat-Business
//
//  Created by 최준영 on 7/14/25.
//

import SwiftUI
//MARK: 마이페이지 커스텀 더보기 메뉴 코드 뜯어보기
struct MyPageMoreMenu: View {
    @Binding var isPresented: Bool
    let actions: [(title: String, action: () -> Void)]
    let anchor: CGRect
    
    var body: some View {
        if isPresented {
            VStack(spacing: 0) {
                ForEach(actions.indices, id: \.self) { idx in
                    Button {    
                        actions[idx].action()
                        isPresented = false
                    } label: {
                        Text(LocalizedStringKey(actions[idx].title))
                            .regular14()
                            .foregroundColor(.primary)
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    if idx < actions.count - 1 {
                        Divider()
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 4)
            )
            .frame(width: 120)
            .position(x: adjustedX, y: adjustedY)
            .transition(.opacity)
            .zIndex(10)
            .background(
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }
            )
        }
    }
    
    // 화면 밖으로 벗어나지 않도록 위치 조정
    private var adjustedX: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let minX = width / 2 + 500
        let maxX = screenWidth - width / 2 - 16
        return min(max(anchor.midX, minX), maxX)
    }
    
    private var adjustedY: CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let menuHeight = CGFloat(actions.count) * 45
        let minY = menuHeight / 2 + 60
        let maxY = screenHeight - menuHeight / 2
        return min(max(anchor.maxY - menuHeight / 2, minY), maxY)
    }
    private let width: CGFloat = 120
}







