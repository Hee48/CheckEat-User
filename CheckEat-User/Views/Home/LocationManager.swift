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
    @Published var userLocation: CLLocationCoordinate2D? = nil
    @Published var centerMapOnLocation: CLLocationCoordinate2D? = nil

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
