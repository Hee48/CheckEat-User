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
                    
                    Text("리뷰 작성을 위한\n영수증 이미지가 필요해요.")
                        .lineSpacing(4)
                        .multilineTextAlignment(.center)
                        .bold20()
                        .padding(.top, 20)
                    
                    Text("카메라로 촬영하거나\n앨범에서 선택해 주세요.")
                        .lineSpacing(4)
                        .multilineTextAlignment(.center)
                        .regular16()
                        .padding(.top, 8)
                    
                    Button {
                        showSourcePicker = true
                    } label: {
                        Text("사진추가")
                            .primaryButtonStyle(isEnabled: true)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                    }
                }
                
                Spacer()
            }
            
            .actionSheet(isPresented: $showSourcePicker) {
                ActionSheet(
                    title: Text("이미지를 선택하세요"),
                    buttons: [
                        .default(Text("카메라로 촬영")) {
                            selectedSourceType = .camera
                            showImagePicker = true
                        },
                        .default(Text("앨범에서 선택")) {
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
                    
                    Text("이미지를 분석 중입니다")
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
