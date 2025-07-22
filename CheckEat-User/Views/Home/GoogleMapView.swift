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
        switch filter {
        case "할랄":
            return store.sto_halal == 1 ? .purple : .red
        case "비건":
            return foodVeganLevel == 1 ? (store.sto_halal == 1 ? .green : Color(red: 0.6, green: 1.0, blue: 0.6)) : .clear
        case "락토":
            return foodVeganLevel == 2 ? (store.sto_halal == 1 ? .black : .gray) : .clear
        case "오보":
            return foodVeganLevel == 3 ? (store.sto_halal == 1 ? .yellow : Color(red: 1.0, green: 1.0, blue: 0.7)) : .clear
        case "락토오보":
            return foodVeganLevel == 4 ? (store.sto_halal == 1 ? .orange : Color(red: 1.0, green: 0.8, blue: 0.6)) : .clear
        case "페스코":
            return foodVeganLevel == 5 ? (store.sto_halal == 1 ? .blue : Color(red: 0.6, green: 0.8, blue: 1.0)) : .clear
        case "폴로":
            return foodVeganLevel == 6 ? (store.sto_halal == 1 ? .brown : Color(red: 0.6, green: 0.4, blue: 0.2)) : .clear
        default:
            let level = viewModel.highestVeganLevel(for: store, filter: "")
            switch level {
            case 1: return store.sto_halal == 1 ? .green : Color(red: 0.6, green: 1.0, blue: 0.6)
            case 2: return store.sto_halal == 1 ? .black : .white
            case 3: return store.sto_halal == 1 ? .yellow : Color(red: 1.0, green: 1.0, blue: 0.7)
            case 4: return store.sto_halal == 1 ? .orange : Color(red: 1.0, green: 0.8, blue: 0.6)
            case 5: return store.sto_halal == 1 ? .blue : Color(red: 0.6, green: 0.8, blue: 1.0)
            case 6: return store.sto_halal == 1 ? .brown : Color(red: 0.6, green: 0.4, blue: 0.2)
            default: return store.sto_halal == 1 ? .purple : .red
            }
        }
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
