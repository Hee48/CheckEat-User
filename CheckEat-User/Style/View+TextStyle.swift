//
//  View+TextStyle.swift
//  CheckEat-Business
//
//  Created by 최준영 on 7/7/25.
//

import SwiftUI

extension View {
    // 공통적으로 사용되는 텍스트 스타일
    func medium16() -> some View {
        return self
            .font(.system(size: 16, weight: .medium))
    }
    
    func bold20() -> some View {
        return self
            .font(.system(size: 20, weight: .bold))
    }
    
    func regular16() -> some View {
        return self
            .font(.system(size: 16, weight: .regular))
    }
    
    func semibold16() -> some View {
        return self
            .font(.system(size: 16, weight: .semibold))
    }
    
    func bold14() -> some View {
        return self
            .font(.system(size: 14, weight: .semibold))
    }
    
    func semibold14() -> some View {
        return self
            .font(.system(size: 14, weight: .semibold))
    }
    
    func regular14() -> some View {
        return self
            .font(.system(size: 14, weight: .regular))
    }
    
    func regular12() -> some View {
        return self
            .font(.system(size: 12, weight: .regular))
    }
    
}
