//
//  GoogleMapView.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/21/25.
//

import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {
    
    @Binding var coordinate: CLLocationCoordinate2D?
    @Binding var centerCoordinate: CLLocationCoordinate2D?
    
    var markers: [Store]
    var currentFilter: String
    var viewModel: StoreMapViewModel
    
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
        
        for store in markers {
            let position = CLLocationCoordinate2D(latitude: store.sto_latitude, longitude: store.sto_longitude)
            let marker = GMSMarker(position: position)
            marker.title = store.sto_name
            
            let veganLevel = viewModel.veganLevelFromFilter(filter: currentFilter)
            let color = UIColor(markerColor(for: store, foodVeganLevel: veganLevel, filter: currentFilter))
            
            let iconView = UIImageView(image: UIImage(systemName: markerIcon(for: store)))
            iconView.tintColor = color
            iconView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            marker.iconView = iconView
            
            marker.map = mapView
        }
        
        if let center = centerCoordinate {
            mapView.animate(toLocation: center)
        } else if let defaultCoord = coordinate {
            mapView.animate(toLocation: defaultCoord)
        }
    }
    
    private func markerIcon(for store: Store) -> String {
        if currentFilter == "할랄" {
            return store.sto_halal == 1 ? "figure.mind.and.body.circle.fill" : "xmark.circle.fill"
        }
        return "leaf.circle.fill"
    }
    
    func markerColor(for store: Store, foodVeganLevel: Int?, filter: String) -> Color {
        let veganColors: [Int: (halal: Color, nonHalal: Color)] = [
            1: (.green, Color(red: 0.6, green: 1.0, blue: 0.6)),
            2: (.black, .gray),
            3: (.yellow, Color(red: 1.0, green: 1.0, blue: 0.7)),
            4: (.orange, Color(red: 1.0, green: 0.8, blue: 0.6)),
            5: (.blue, Color(red: 0.6, green: 0.8, blue: 1.0)),
            6: (.brown, Color(red: 0.6, green: 0.4, blue: 0.2))
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
            guard let level = viewModel.highestVeganLevel(for: store, filter: ""),
                  let colorPair = veganColors[level] else {
                return store.sto_halal == 1 ? .purple : .red
            }
            return store.sto_halal == 1 ? colorPair.halal : colorPair.nonHalal
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapView

        init(_ parent: GoogleMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            DispatchQueue.main.async {
                self.parent.centerCoordinate = position.target
                print("📍 중심 좌표 변경 감지: \(position.target.latitude), \(position.target.longitude)")
            }
        }
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
