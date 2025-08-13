//
//  LocationService.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/9/25.
//

import Foundation
import CoreLocation
import Combine

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    // 기본 위치 (서울 시청)
    static let defaultLatitude: CLLocationDegrees = 37.5665
    static let defaultLongitude: CLLocationDegrees = 126.9780
    
    @Published var userLocation: CLLocationCoordinate2D? = nil // 사용자 현재 위치
    @Published var centerMapOnLocation: CLLocationCoordinate2D? = nil
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentMapCenter: CLLocationCoordinate2D? = nil  // 현재 지도 중심점 (옮길 경우)
    @Published var shouldShowSearchButton = false  // 검색 버튼 표시 여부
    
    private var lastSearchLocation: CLLocationCoordinate2D?  // 마지막 검색 위치
    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.requestWhenInUseAuthorization()
        
        authorizationStatus = locationManager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.userLocation = location.coordinate
            if self.centerMapOnLocation == nil {
                self.centerMapOnLocation = location.coordinate
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ 위치 업데이트 실패: \(error.localizedDescription)")
        
        DispatchQueue.main.async {
            if self.centerMapOnLocation == nil {
                self.centerMapOnLocation = CLLocationCoordinate2D(
                    latitude: Self.defaultLatitude,
                    longitude: Self.defaultLongitude
                )
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus
            
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                self.locationManager.startUpdatingLocation()
                print("✅ 위치 권한 허용, GPS 가능")
                
                // 권한 허용 후 즉시 위치 업데이트 시작
                if let location = self.locationManager.location {
                    self.userLocation = location.coordinate
                    self.currentMapCenter = location.coordinate
                    self.lastSearchLocation = location.coordinate
                    
                    // 위치 설정 후 즉시 가게 검색 실행
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.performInitialSearch(viewModel: nil)
                    }
                }
                
            case .notDetermined:
                print("❓ 위치 권한이 아직 설정되기 전입니다.")
                break
                
            case .restricted, .denied:
                print("❌ 위치 권한이 거부되었거나 제한되었습니다.")
                if self.centerMapOnLocation == nil {
                    self.centerMapOnLocation = CLLocationCoordinate2D(
                        latitude: Self.defaultLatitude,
                        longitude: Self.defaultLongitude
                    )
                }
                
            @unknown default:
                break
            }
        }
    }
    
    // 지도 중심점 업데이트 (Google Maps에서 호출)
    func updateMapCenter(_ center: CLLocationCoordinate2D) {
        currentMapCenter = center
    }
    
    // 수동으로 가게 목록 조회
    func fetchStoresAtCurrentCenter(viewModel: NearByStoreViewModel) {
        guard let center = currentMapCenter else { return }
        
        // 검색 버튼 숨기기
        shouldShowSearchButton = false
        // 마지막 검색 위치 업데이트
        lastSearchLocation = center
        
        viewModel.fetchNearByStores(
            latitude: String(center.latitude),
            longitude: String(center.longitude),
            radius: "10000" // 10km 반경 설정
        )
    }
    
    // 100m 이상 움직였는지 체크
    func updateNearbyIfNeeded(_ center: CLLocationCoordinate2D, viewModel: NearByStoreViewModel) {
        if let lastSearch = lastSearchLocation {
            let distance = calculateDistance(from: center, to: lastSearch)
            print("📍 거리 계산: 현재 중심점과 마지막 검색 위치 간 거리 = \(distance)m")
            
            if distance > 100 { // 100m 이상 움직였으니 검색 버튼 표시 필요
                shouldShowSearchButton = true
                print("📍 100m 이상 움직임: \(distance)m, 검색 버튼 표시됨")
            } else if distance <= 50 { // 50m 이내로 돌아왔으면 검색 버튼 숨기기
                shouldShowSearchButton = false
                print("📍 50m 이내로 돌아옴: \(distance)m, 검색 버튼 숨김됨")
            } else {
                print("📍 50m~100m 사이: \(distance)m, 검색 버튼 상태 유지 (현재: \(shouldShowSearchButton))")
            }
        } else {
            // 처음 검색하는 경우
            lastSearchLocation = center
            shouldShowSearchButton = false
            print("📍 처음 검색: lastSearchLocation 설정, 검색 버튼 숨김")
        }
        
        // GPS 위치와도 비교하여 현재 위치 근처로 돌아왔는지 확인
        if let userLocation = userLocation {
            let gpsDistance = calculateDistance(from: center, to: userLocation)
            print("📍 GPS 거리: 현재 중심점과 GPS 위치 간 거리 = \(gpsDistance)m")
            
            if gpsDistance <= 50 && shouldShowSearchButton {
                shouldShowSearchButton = false
                print("📍 GPS 위치 50m 이내로 돌아옴: \(gpsDistance)m, 검색 버튼 숨김됨")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.performSearchAtCurrentLocation(viewModel: viewModel)
                }
            }
        }
    }
    
    // 두 좌표 간의 거리 계산 (미터 단위)
    private func calculateDistance(from coord1: CLLocationCoordinate2D, to coord2: CLLocationCoordinate2D) -> Double {
        let location1 = CLLocation(latitude: coord1.latitude, longitude: coord1.longitude)
        let location2 = CLLocation(latitude: coord2.latitude, longitude: coord2.longitude)
        return location1.distance(from: location2)
    }
    
    // 초기 검색 실행 (앱 시작시 또는 위치 권한 허용 후)
    func performInitialSearch(viewModel: NearByStoreViewModel?) {
        if let userLocation = userLocation {
            currentMapCenter = userLocation
            lastSearchLocation = userLocation
            shouldShowSearchButton = false
            
            print("🚀 초기 검색 실행: \(userLocation.latitude), \(userLocation.longitude)")
            
            // viewModel이 있을 때만 검색 실행
            if let viewModel = viewModel {
                viewModel.fetchNearByStores(
                    latitude: String(userLocation.latitude),
                    longitude: String(userLocation.longitude),
                    radius: "10000"
                )
            }
        } else {
            print("⚠️ 사용자 위치가 아직 없음")
        }
    }
    
    // 현재 위치에서 가게 검색 실행 (자동 실행용)
    func performSearchAtCurrentLocation(viewModel: NearByStoreViewModel?) {
        guard let userLocation = userLocation else {
            print("⚠️ 사용자 위치가 없어서 검색할 수 없음")
            return
        }
        
        // 지도 중심을 현재 위치로 업데이트
        currentMapCenter = userLocation
        lastSearchLocation = userLocation
        
        print("🔄 현재 위치에서 자동 검색 실행: \(userLocation.latitude), \(userLocation.longitude)")
        
        // viewModel이 있을 때만 검색 실행
        if let viewModel = viewModel {
            viewModel.fetchNearByStores(
                latitude: String(userLocation.latitude),
                longitude: String(userLocation.longitude),
                radius: "10000"
            )
        }
    }
}
