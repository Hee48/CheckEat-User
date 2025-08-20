//
//  OCRView.swift
//  CheckEat-User
//
//  Created by Hee  on 8/4/25.
//

import SwiftUI

struct OCRView: View {
    @State private var capturedImage: UIImage?
    @State private var showSourcePicker = false
    @State private var showImagePicker = false
    @State private var showOCRView = false
    @State private var selectedSourceType: UIImagePickerController.SourceType = .camera
    @StateObject private var viewModel = OCRViewModel()
    @StateObject private var reviewViewModel = ReviewViewModel()
    @State private var showCheckModal = false
    @State private var storeName = ""
    @State private var storeAddress = ""
    @State private var isLoading: Bool = false
    
    @Binding var isReviewFlowActive: Bool
    @Binding var reviewPath: [ReviewPath]
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: 100)
                
                VStack {
                    Image("OCR")
                        .resizable()
                        .frame(width: 40, height: 40 )
                        .padding(.top, 24)
                    
                    Text("ocr_title".localized)
                        .lineSpacing(4)
                        .multilineTextAlignment(.center)
                        .bold20()
                        .padding(.top, 20)
                    
                    Text("ocr_subtitle".localized)
                        .lineSpacing(4)
                        .multilineTextAlignment(.center)
                        .regular16()
                        .padding(.top, 8)
                    
                    Button {
                        showSourcePicker = true
                    } label: {
                        Text("ocr_add_photo_button".localized)
                            .primaryButtonStyle(isEnabled: true)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                    }
                }
                
                Spacer()
            }
            
            .actionSheet(isPresented: $showSourcePicker) {
                ActionSheet(
                    title: Text("ocr_picker_title".localized),
                    buttons: [
                        .default(Text("ocr_take_photo".localized)) {
                            selectedSourceType = .camera
                            showImagePicker = true
                        },
                        .default(Text("ocr_pick_from_album".localized)) {
                            selectedSourceType = .photoLibrary
                            showImagePicker = true
                        },
                        .cancel() {
                            showSourcePicker = false
                        }
                    ]
                )
            }
            .fullScreenCover(isPresented: $showImagePicker) {
                CameraCaptureView(
                    capturedImage: $capturedImage,
                    onDismiss: {
                        showImagePicker = false
                    },
                    sourceType: selectedSourceType
                )
                .ignoresSafeArea()
            }
            .onChange(of: capturedImage) { newImage in
                if let image = newImage, let imageData = image.jpegData(compressionQuality: 0.8) {
                    isLoading = true
                    viewModel.performOCR(with: imageData)
                }
            }
            .onChange(of: viewModel.ocrResult) { newResult in
                if let result = newResult {
                    isLoading = false
                    print("📸 OCR 결과 - 가게명: \(result.store)")
                    storeName = result.store
                    if let address = result.address {
                        print("📍 주소: \(address)")
                        storeAddress = result.address ?? ""
                        //                    reviewPath.append(.checkModal)
                        showCheckModal = true
                    }
                }
            }
            .sheet(isPresented: $showCheckModal) {
                CheckModal(
                    showCheckModal: $showCheckModal,
                    storeName: $storeName,
                    storeAddress: $storeAddress,
                    showOCRView: $showOCRView,
                    reviewPath: $reviewPath,
                    isReviewFlowActive: $isReviewFlowActive,
                    isPresented: $showCheckModal
                )
                .presentationDetents([.height(350)])
                .environmentObject(reviewViewModel)
            }
            // OCR 처리 중일 때 표시할 로딩 뷰
            if isLoading {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    
                    Text("ocr_analyzing".localized)
                        .foregroundColor(.white)
                        .bold()
                }
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(12)
            }
        }
    }
}
