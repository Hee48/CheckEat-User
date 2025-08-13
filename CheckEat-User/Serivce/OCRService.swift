//
//  OCRService.swift
//  CheckEat-User
//
//  Created by Hee  on 8/4/25.
//

import Foundation
import Alamofire
import Combine
import UIKit

final class OCRService {
    static let shared = OCRService()

    func sendImageToAzureOCR(imageData: Data) -> AnyPublisher<OCRResponse, AFError> {
        AF.upload(multipartFormData: { multipart in
            multipart.append(imageData, withName: "file", fileName: "receipt.jpg", mimeType: "image/jpeg")
        }, to: OCRAPI.ocrURL)
        .validate()
        .publishDecodable(type: OCRResponse.self)
        .value()
        .eraseToAnyPublisher()
    }
}
