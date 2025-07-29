//
//  LocationManager.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/21/25.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    // 기본 위치 (서울 시청)
    static let defaultLatitude: CLLocationDegrees = 37.5665
    static let defaultLongitude: CLLocationDegrees = 126.9780
    @Published var userLocation: CLLocationCoordinate2D? = nil
    @Published var centerMapOnLocation: CLLocationCoordinate2D? = nil
    @Published var didInitialLocationUpdate: Bool = false
    @Published var lastPresentedCenter: CLLocationCoordinate2D? = nil

    var locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
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
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            // ✅ 위치 사용 가능
        case .notDetermined:
            // 요청만 하고 대기
            // 🔄 권한 아직 요청 안 함
            break
        case .restricted, .denied:
            print("❌ 위치 권한이 거부되었거나 제한되었습니다.")
        @unknown default:
            break
        }
    }
}

extension LocationManager {
    func updateNearbyIfNeeded(_ center: CLLocationCoordinate2D, viewModel: StoreMapViewModel) {
        let defaultLat = 37.5665
        let defaultLng = 126.9780

        if !didInitialLocationUpdate {
            if abs(center.latitude - defaultLat) > 0.0005 || abs(center.longitude - defaultLng) > 0.0005 {
                viewModel.updateNearbyStores(center: center)
                self.centerMapOnLocation = center
                self.lastPresentedCenter = center
                self.didInitialLocationUpdate = true
            }
            return
        }

        if let last = lastPresentedCenter {
            let distance = CLLocation(latitude: center.latitude, longitude: center.longitude)
                .distance(from: CLLocation(latitude: last.latitude, longitude: last.longitude))
            if distance > 100 {
                viewModel.updateNearbyStores(center: center)
                self.lastPresentedCenter = center
            }
        } else {
            viewModel.updateNearbyStores(center: center)
            self.lastPresentedCenter = center
        }
    }
}
