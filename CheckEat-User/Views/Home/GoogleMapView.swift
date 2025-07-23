//
//  GoogleMapView.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/21/25.
//

import SwiftUI
import GoogleMaps
import CoreLocation

struct GoogleMapView: UIViewRepresentable {
    
    @Binding var coordinate: CLLocationCoordinate2D?
    @Binding var centerCoordinate: CLLocationCoordinate2D?
    @Binding var isNearbyPresented: Bool
    @Binding var mapZoomLevel: Float
    
    var markers: [Store]
    var currentFilter: String
    var viewModel: StoreMapViewModel
    
    @State static var didShowModal = false
    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: 37.5665, longitude: 126.9780, zoom: 13)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        mapView.clear()
        
        let ids = markers.map { $0.storeId }
        let dupIds = Dictionary(grouping: ids, by: { $0 }).filter { $1.count > 1 }
        print("🔁 중복된 storeId 목록: \(dupIds.keys)")
        
        // 좌표 기준 중복 카운트 사전
        let coordinateCounts = Dictionary(grouping: markers, by: { "\($0.sto_latitude),\($0.sto_longitude)" }).mapValues { $0.count }

        for store in markers {
            let coordKey = "\(store.sto_latitude),\(store.sto_longitude)"
            let duplicateCount = coordinateCounts[coordKey] ?? 1
            let positionIndex = markers.prefix(while: { $0.storeId != store.storeId }).filter { $0.sto_latitude == store.sto_latitude && $0.sto_longitude == store.sto_longitude }.count
            let originalPosition = CLLocationCoordinate2D(latitude: store.sto_latitude, longitude: store.sto_longitude)
            let position = duplicateCount > 1 ? offsetCoordinate(originalPosition, index: positionIndex) : originalPosition
            let marker = GMSMarker(position: position)
            marker.title = store.sto_name
            
            let veganLevel: Int? = viewModel.veganLevelFromFilter(filter: currentFilter)
            let color = markerColor(for: store, foodVeganLevel: veganLevel, filter: currentFilter)
            
            // 이전 로직: 전체보기일 때 비건 캐시에서 가장 엄격한 단계 사용
            // let veganLevel: Int?
            // if currentFilter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || currentFilter == "" {
            //     veganLevel = viewModel.cachedVeganLevel(for: store)
            // } else {
            //     veganLevel = viewModel.highestVeganLevel(for: store, filter: currentFilter)
            // }

//            let veganLevel: Int? = nil
            
//            let veganLevel: Int?
//            if currentFilter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || currentFilter == "" {
//                veganLevel = viewModel.cachedVeganLevel(for: store)
//            } else {
//                veganLevel = viewModel.highestVeganLevel(for: store, filter: currentFilter)
//            }
            
//            if let cached = viewModel.cachedVeganLevel(for: store) {
//                print("✅ \(store.sto_name) → storeId: \(store.storeId) → veganLevel: \(cached)")
//            } else {
//                print("❌ \(store.sto_name) → storeId: \(store.storeId) → 캐시 없음")
//            }
            
//            let color = markerColor(for: store, foodVeganLevel: veganLevel, filter: currentFilter)
            
            //MARK: 이미지 깜빡임 (좌표 동일)
            let iconView = UIImageView(image: UIImage(systemName: markerIcon(for: store)))
            iconView.tintColor = color
            iconView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            marker.iconView = iconView
            marker.map = mapView
            
//            let iconName = markerIcon(for: store)
//            if let baseImage = UIImage(systemName: iconName)?.withRenderingMode(.alwaysTemplate) {
//                let renderer = UIGraphicsImageRenderer(size: CGSize(width: 32, height: 32))
//                let image = renderer.image { _ in
//                    color.set()
//                    baseImage.draw(in: CGRect(origin: .zero, size: CGSize(width: 32, height: 32)))
//                }
//                marker.icon = image
//                marker.map = mapView
//            } else {
//                print("⚠️ 마커 아이콘 로드 실패: \(iconName) for store \(store.sto_name)")
//            }
        }
        
        if let center = centerCoordinate {
            mapView.animate(toLocation: center)
        } else if let defaultCoord = coordinate {
            mapView.animate(toLocation: defaultCoord)
        }
    }

    private func offsetCoordinate(_ coord: CLLocationCoordinate2D, index: Int) -> CLLocationCoordinate2D {
        let offset = 0.001 * Double(index)
        return CLLocationCoordinate2D(latitude: coord.latitude + offset, longitude: coord.longitude + offset)
    }
    
    private func markerIcon(for store: Store) -> String {
        if currentFilter == "할랄" {
            return store.sto_halal == 1 ? "figure.mind.and.body.circle.fill" : "xmark.circle.fill"
        }
        return "leaf.circle.fill"
    }
    
    func markerColor(for store: Store, foodVeganLevel: Int?, filter: String) -> UIColor {
        let veganColors: [Int: (halal: UIColor, nonHalal: UIColor)] = [
            1: (.green, UIColor(red: 0.6, green: 1.0, blue: 0.6, alpha: 1)),
            2: (.black, .gray),
            3: (.yellow, UIColor(red: 1.0, green: 1.0, blue: 0.7, alpha: 1)),
            4: (.orange, UIColor(red: 1.0, green: 0.8, blue: 0.6, alpha: 1)),
            5: (.blue, UIColor(red: 0.6, green: 0.8, blue: 1.0, alpha: 1)),
            6: (.brown, UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1))
        ]

        switch filter {
        case "할랄":
            return store.sto_halal == 1 ? .purple : .red
        case "비건", "락토", "오보", "락토오보", "페스코", "폴로":
            if let level = foodVeganLevel, let colorPair = veganColors[level] {
                return store.sto_halal == 1 ? colorPair.halal : colorPair.nonHalal
            } else {
                return .clear
            }
        default:
            if let level = foodVeganLevel, let colorPair = veganColors[level] {
                return store.sto_halal == 1 ? colorPair.halal : colorPair.nonHalal
            } else {
                return store.sto_halal == 1 ? .purple : .red
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate, CLLocationManagerDelegate {
        var parent: GoogleMapView
        private var didInitialLocationUpdate = false
        private let locationManager = CLLocationManager()

        init(_ parent: GoogleMapView) {
            self.parent = parent
            super.init()
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }

        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            DispatchQueue.main.async {
                self.parent.centerCoordinate = position.target
                if self.parent.centerCoordinate != self.parent.coordinate {
                    self.parent.coordinate = self.parent.centerCoordinate
                }
                print("📍 중심 좌표 변경 감지: \(position.target.latitude), \(position.target.longitude)")
                let cameraZoom = mapView.camera.zoom
                print("🔍 현재 줌 레벨: \(cameraZoom)")
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first?.coordinate else { return }

            // 위치 권한 상태 확인
            let status = CLLocationManager.authorizationStatus()
            let isAuthorized = status == .authorizedWhenInUse || status == .authorizedAlways

            if !didInitialLocationUpdate && isAuthorized {
                let latitude = location.latitude
                let longitude = location.longitude

                let isDifferentFromDefault = abs(latitude - 37.5665) > 0.0001 || abs(longitude - 126.9780) > 0.0001

                if isDifferentFromDefault {
                    DispatchQueue.main.async {
                        self.parent.centerCoordinate = location
                        self.parent.coordinate = location
                        self.parent.isNearbyPresented = true
                    }
                    didInitialLocationUpdate = true
                }
            }
        }
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
