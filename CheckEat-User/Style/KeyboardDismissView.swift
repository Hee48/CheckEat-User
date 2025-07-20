//
//  KeyboardDismissView.swift
//  CheckEat-Business
//
//  Created by 최준영 on 7/7/25.
//

import SwiftUI

struct KeyboardDismissView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: context.coordinator,
                                                action: #selector(Coordinator.handleTap))
        tapGesture.cancelsTouchesInView = false // 버튼/텍스트필드/이미지 동작 막지 않음
        view.addGestureRecognizer(tapGesture)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject {
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            let location = sender.location(in: sender.view)
            if let hitView = sender.view?.hitTest(location, with: nil) {
                // UIControl(버튼, 텍스트필드) 영역 터치 시 키보드 유지
                if hitView is UIControl {
                    return
                }
            }
            // 그 외 영역 터치 시 키보드 내림
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
        }
    }
}

struct TapToDismissKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                KeyboardDismissView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .allowsHitTesting(true)
            )
    }
}

extension View {
    func tapToDismissKeyboard() -> some View {
        self.modifier(TapToDismissKeyboard())
    }
}
