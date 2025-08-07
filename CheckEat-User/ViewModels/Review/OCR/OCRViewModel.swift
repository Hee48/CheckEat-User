//
//  OCRViewModel.swift
//  CheckEat-User
//
//  Created by Hee  on 8/4/25.
//

import Foundation
import Combine
import Alamofire


class OCRViewModel: ObservableObject {
    @Published var ocrResult: OCRResponse?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private var cancellables = Set<AnyCancellable>()

    func performOCR(with imageData: Data) {
        isLoading = true
        errorMessage = nil

        print("🚀 OCR 요청 시작")
        print("📦 이미지 데이터 크기: \(imageData.count) bytes")

        OCRService.shared.sendImageToAzureOCR(imageData: imageData)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("❌ OCR 실패: \(error)")
                case .finished:
                    print("✅ 요청 완료")
                }
            } receiveValue: { [weak self] response in
                self?.ocrResult = response
                print("📥 OCR 응답 수신 완료")
            }
            .store(in: &cancellables)
    }

    func reset() {
        ocrResult = nil
        errorMessage = nil
        isLoading = false
    }
}
