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
    @Binding var selectedStore: Store?
    
    var markers: [Store]
    var currentFilter: String
    var viewModel: StoreMapViewModel
    
    @State static var didShowModal = false
    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: 37.5665, longitude: 126.9780, zoom: 15)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        mapView.clear()
        
        let storesToRender = viewModel.isFavoriteMode ? viewModel.favoriteStores : markers
        let coordinateCounts = Dictionary(grouping: storesToRender, by: { "\($0.sto_latitude),\($0.sto_longitude)" }).mapValues { $0.count }
        
        for store in storesToRender {
            let coordKey = "\(store.sto_latitude),\(store.sto_longitude)"
            let duplicateCount = coordinateCounts[coordKey] ?? 1
            let positionIndex = markers.prefix(while: { $0.storeId != store.storeId }).filter { $0.sto_latitude == store.sto_latitude && $0.sto_longitude == store.sto_longitude }.count
            let originalPosition = CLLocationCoordinate2D(latitude: store.sto_latitude, longitude: store.sto_longitude)
            let position = duplicateCount > 1 ? offsetCoordinate(originalPosition, index: positionIndex) : originalPosition
            let marker = GMSMarker(position: position)
            marker.title = store.sto_name
            
            let veganLevel: Int? = viewModel.veganLevelFromFilter(filter: currentFilter)
            let color = markerColor(for: store, foodVeganLevel: veganLevel, filter: currentFilter)
            
            //MARK: 이미지 깜빡임 (좌표 동일)
            let container = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
            
            let imageView = UIImageView(image: UIImage(systemName: markerIcon(for: store)))
            imageView.tintColor = color
            imageView.frame = CGRect(x: 34, y: 0, width: 32, height: 32)
            container.addSubview(imageView)
            
            let label = UILabel(frame: CGRect(x: 0, y: 32, width: 100, height: 12))
            label.text = store.sto_name
            label.font = UIFont.systemFont(ofSize: 10)
            label.textAlignment = .center
            label.textColor = .black
            label.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
            label.layer.cornerRadius = 4
            label.layer.masksToBounds = true
            label.adjustsFontSizeToFitWidth = true
            container.addSubview(label)
            
            marker.iconView = container
            marker.map = mapView
            marker.userData = store
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
        if viewModel.isFavoriteMode {
            return "star.circle.fill"
        }
        return "leaf.circle.fill"
    }
    
    func markerColor(for store: Store, foodVeganLevel: Int?, filter: String) -> UIColor {
        
        if viewModel.isFavoriteMode {
                return .systemPink
            }
        
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
            return store.sto_halal == 1 ? .purple : .darkGray
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
                return store.sto_halal == 1 ? .purple : .darkGray
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
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            if let store = marker.userData as? Store {
                DispatchQueue.main.async {
                    self.parent.selectedStore = store
                }
            }
            return false // Let the map handle the default tap behavior too
        }
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}


