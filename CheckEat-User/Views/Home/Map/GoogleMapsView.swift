//
//  GoogleMapsView.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/9/25.
//

import SwiftUI
import GoogleMaps
import CoreLocation

struct GoogleMapsView: UIViewRepresentable {
    @Binding var center: CLLocationCoordinate2D?
    @Binding var zoomLevel: Float
    let onCenterChanged: (CLLocationCoordinate2D) -> Void
    let stores: [Stores]
    let shouldShowSearchButton: Bool
    let onSearchButtonTapped: () -> Void
    
    // 마커 커스텀을 위한 추가 프로퍼티들
    let currentFilter: String
    let isFavoriteMode: Bool
    let isSearchMode: Bool // 검색 모드 여부 추가
    let isFilterMode: Bool // 필터 모드 여부 추가
    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(
            withLatitude: center?.latitude ?? 37.5665,
            longitude: center?.longitude ?? 126.9780,
            zoom: zoomLevel
        )
        
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.delegate = context.coordinator
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.settings.zoomGestures = true
        mapView.settings.scrollGestures = true
        mapView.settings.rotateGestures = true
        mapView.settings.tiltGestures = true
        
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        // 중심점 업데이트
        if let center = center {
            let camera = GMSCameraPosition.camera(
                withLatitude: center.latitude,
                longitude: center.longitude,
                zoom: zoomLevel
            )
            mapView.animate(to: camera)
        }
        
        // 줌 레벨 업데이트
        if abs(mapView.camera.zoom - zoomLevel) > 0.1 {
            mapView.animate(toZoom: zoomLevel)
        }
        
        // 마커 업데이트 (줌 레벨 고려)
        updateMarkers(on: mapView, zoomLevel: zoomLevel)
        
        // 검색 버튼 표시/숨김
        updateSearchButton(on: mapView, context: context)
        
        print("🔍 shouldShowSearchButton: \(shouldShowSearchButton), stores count: \(stores.count)")
        
        // 디버깅: 검색 버튼 상태 변화 추적
        if shouldShowSearchButton {
            print("🔘 검색 버튼 표시 상태: true")
        } else {
            print("🔘 검색 버튼 표시 상태: false")
        }
    }
    
    private func updateMarkers(on mapView: GMSMapView, zoomLevel: Float) {
        // 기존 마커 제거
        mapView.clear()
        
        // 줌 레벨에 따른 표시 방식 결정
        if zoomLevel < 14.0 {
            // 줌이 멀리 있을 때: 클러스터링
            updateMarkersWithClustering(on: mapView)
        } else if zoomLevel < 16.0 {
            // 중간 줌: 오프셋 적용한 개별 마커
            updateMarkersWithOffset(on: mapView)
        } else {
            // 가까운 줌: 모든 마커 표시 (겹치는 경우 오프셋)
            updateMarkersIndividually(on: mapView)
        }
    }
    
    private func updateMarkersWithClustering(on mapView: GMSMapView) {
        // 좌표 그룹화 (더 정밀한 그룹화)
        var markerGroups: [String: [Stores]] = [:]
        
        for store in stores {
            // 좌표를 소수점 6자리로 반올림하여 그룹화 (약 1m 단위)
            let lat = round(store.sto_latitude * 1000000) / 1000000
            let lng = round(store.sto_longitude * 1000000) / 1000000
            let key = "\(lat),\(lng)"
            
            if markerGroups[key] == nil {
                markerGroups[key] = []
            }
            markerGroups[key]?.append(store)
        }
        
        // 클러스터 마커 생성
        for (_, storeGroup) in markerGroups {
            if storeGroup.count == 1 {
                // 단일 마커
                createIndividualMarker(for: storeGroup[0], on: mapView)
            } else {
                // 클러스터 마커 (여러 가게가 같은 좌표)
                createClusterMarker(for: storeGroup, on: mapView)
            }
        }
    }
    
    private func updateMarkersWithOffset(on mapView: GMSMapView) {
        // 좌표별로 그룹화하여 오프셋 적용
        var coordinateGroups: [String: [Stores]] = [:]
        
        for store in stores {
            let key = "\(store.sto_latitude),\(store.sto_longitude)"
            if coordinateGroups[key] == nil {
                coordinateGroups[key] = []
            }
            coordinateGroups[key]?.append(store)
        }
        
        // 각 그룹의 마커에 오프셋 적용
        for (_, storeGroup) in coordinateGroups {
            for (index, store) in storeGroup.enumerated() {
                createIndividualMarkerWithOffset(for: store, on: mapView, index: index, total: storeGroup.count)
            }
        }
    }
    
    private func updateMarkersIndividually(on mapView: GMSMapView) {
        // 좌표별로 그룹화하여 오프셋 적용
        var coordinateGroups: [String: [Stores]] = [:]
        
        for store in stores {
            let key = "\(store.sto_latitude),\(store.sto_longitude)"
            if coordinateGroups[key] == nil {
                coordinateGroups[key] = []
            }
            coordinateGroups[key]?.append(store)
        }
        
        // 각 그룹의 마커에 오프셋 적용
        for (_, storeGroup) in coordinateGroups {
            for (index, store) in storeGroup.enumerated() {
                createIndividualMarkerWithOffset(for: store, on: mapView, index: index, total: storeGroup.count)
            }
        }
    }
    
    private func createIndividualMarker(for store: Stores, on mapView: GMSMapView) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(
            latitude: store.sto_latitude,
            longitude: store.sto_longitude
        )
        marker.title = store.sto_name
        marker.snippet = store.sto_address
        
        // 커스텀 마커 아이콘 생성
        let customIconView = createCustomMarkerView(for: store)
        marker.iconView = customIconView
        
        marker.map = mapView
    }
    
    private func createIndividualMarkerWithOffset(for store: Stores, on mapView: GMSMapView, index: Int, total: Int) {
        let marker = GMSMarker()
        
        // 원래 좌표
        let originalPosition = CLLocationCoordinate2D(
            latitude: store.sto_latitude,
            longitude: store.sto_longitude
        )
        
        // 오프셋 계산 (원형으로 배치)
        let radius = 0.0001 // 약 10m 정도의 오프셋
        let angle = (2 * Double.pi * Double(index)) / Double(total)
        let offsetLat = radius * cos(angle)
        let offsetLng = radius * sin(angle)
        
        let newPosition = CLLocationCoordinate2D(
            latitude: originalPosition.latitude + offsetLat,
            longitude: originalPosition.longitude + offsetLng
        )
        
        marker.position = newPosition
        marker.title = store.sto_name
        marker.snippet = store.sto_address
        
        // 커스텀 마커 아이콘 생성
        let customIconView = createCustomMarkerView(for: store)
        marker.iconView = customIconView
        
        marker.map = mapView
    }
    
    private func createCustomMarkerView(for store: Stores) -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        
        let imageView = UIImageView(image: UIImage(systemName: markerIcon(for: store)))
        imageView.tintColor = markerColor(for: store)
        imageView.frame = CGRect(x: 34, y: 0, width: 32, height: 32)
        container.addSubview(imageView)
        
        return container
    }
    
    private func markerIcon(for store: Stores) -> String {
        // 비건 필터로 검색된 결과인 경우에만 나뭇잎 모양
        if isFilterMode && !currentFilter.isEmpty && currentFilter != "마이필터" {
            return "leaf.circle.fill" // 비건 필터: 나뭇잎 모양
        } else {
            // 기본 아이콘은 할랄 여부에 따라
            if store.sto_halal == 1 {
                return "figure.mind.and.body.circle.fill" // 할랄 인증 가게
            } else {
                return "pin.circle.fill" // 할랄 인증 안된 가게
            }
        }
    }
    
    private func markerColor(for store: Stores) -> UIColor {
        // 비건 필터로 검색된 결과인 경우에만 레벨별 색상
        if isFilterMode && !currentFilter.isEmpty && currentFilter != "마이필터" {
            return veganLevelColor(for: store, filter: currentFilter)
        } else {
            // 기본 색상은 할랄 여부에 따라
            if store.sto_halal == 1 {
                return .purple // 할랄 인증 가게: 보라색
            } else {
                return .gray // 할랄 인증 안된 가게: 그레이
            }
        }
    }
    
    // 비건 레벨에 따른 색상 반환
    private func veganLevelColor(for store: Stores, filter: String) -> UIColor {
        switch filter {
        case "비건":
            return .green // 비건: 초록색
        case "락토":
            return .blue // 락토: 파란색
        case "오보":
            return .orange // 오보: 주황색
        case "락토오보":
            return .cyan // 락토오보: 청록색
        case "페스코":
            return .brown // 페스코: 갈색
        case "폴로":
            return .magenta // 폴로: 마젠타
        default:
            return .gray // 기본값
        }
    }
    
    private func createClusterMarker(for storeGroup: [Stores], on mapView: GMSMapView) {
        let firstStore = storeGroup[0]
        let hasHalal = storeGroup.contains { $0.sto_halal == 1 }
        
        let clusterMarker = GMSMarker()
        clusterMarker.position = CLLocationCoordinate2D(
            latitude: firstStore.sto_latitude,
            longitude: firstStore.sto_longitude
        )
        
        // 클러스터 아이콘 생성
        let clusterView = createClusterView(
            count: storeGroup.count,
            hasHalal: hasHalal
        )
        clusterMarker.iconView = clusterView
        clusterMarker.map = mapView
        
        // 클러스터 탭시 줌인
        clusterMarker.userData = storeGroup
    }
    
    private func createClusterView(count: Int, hasHalal: Bool) -> UIView {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        // 배경 원
        let circleView = UIView()
        circleView.frame = containerView.bounds
        circleView.backgroundColor = hasHalal ? .purple : .gray
        circleView.layer.cornerRadius = 22
        circleView.layer.borderWidth = 2
        circleView.layer.borderColor = UIColor.white.cgColor
        circleView.layer.shadowColor = UIColor.black.cgColor
        circleView.layer.shadowOffset = CGSize(width: 0, height: 2)
        circleView.layer.shadowOpacity = 0.3
        circleView.layer.shadowRadius = 4
        
        // 숫자 라벨
        let label = UILabel()
        label.text = "\(count)"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.frame = containerView.bounds
        
        containerView.addSubview(circleView)
        containerView.addSubview(label)
        
        return containerView
    }
    
    private func updateSearchButton(on mapView: GMSMapView, context: Context) {
        // 기존 검색 버튼과 현재위치 버튼 제거
        mapView.subviews.forEach { subview in
            if subview.tag == 999 {
                subview.removeFromSuperview()
            }
        }
        
        // 검색 버튼이 표시되어야 하는 경우에만 추가
        if shouldShowSearchButton {
            let searchButton = UIButton(type: .system)
            searchButton.tag = 999
            searchButton.setTitle("현재 위치에서 검색", for: .normal)
            searchButton.setTitleColor(.buttonOP50, for: .normal)
            searchButton.backgroundColor = .white
            searchButton.layer.cornerRadius = 18
            searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            searchButton.layer.borderWidth = 1.0
            searchButton.layer.borderColor = UIColor.systemGray3.cgColor
            
            searchButton.addTarget(context.coordinator, action: #selector(Coordinator.searchButtonTapped), for: .touchUpInside)
            
            // 검색 버튼 위치 설정 (센터 상단, 가운데 정렬)
            searchButton.translatesAutoresizingMaskIntoConstraints = false
            mapView.addSubview(searchButton)
            
            NSLayoutConstraint.activate([
                searchButton.topAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.topAnchor, constant: 150), // 서치바
                searchButton.centerXAnchor.constraint(equalTo: mapView.centerXAnchor), // 가운데 정렬
                searchButton.heightAnchor.constraint(equalToConstant: 36),
                searchButton.widthAnchor.constraint(equalToConstant: 150) // 버튼 너비 고정
            ])
        } else {
            print("🔘 검색 버튼 숨김")
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapsView
        
        init(_ parent: GoogleMapsView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            // 지도 이동이 멈췄을 때 중심점 업데이트
            let newCenter = position.target
            print("🗺️ 지도 중심점 변경: \(newCenter.latitude), \(newCenter.longitude)")
            parent.onCenterChanged(newCenter)
            
            // 줌 레벨 업데이트
            parent.zoomLevel = position.zoom
        }
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            // 클러스터 마커 탭시 줌인
            if let storeGroup = marker.userData as? [Stores], storeGroup.count > 1 {
                let bounds = GMSCoordinateBounds()
                for store in storeGroup {
                    bounds.includingCoordinate(CLLocationCoordinate2D(
                        latitude: store.sto_latitude,
                        longitude: store.sto_longitude
                    ))
                }
                
                let update = GMSCameraUpdate.fit(bounds, withPadding: 50)
                mapView.animate(with: update)
                return true
            }
            
            return false
        }
        
        @objc func searchButtonTapped() {
            print("🔘 검색 버튼 탭됨")
            parent.onSearchButtonTapped()
        }
    }
}
