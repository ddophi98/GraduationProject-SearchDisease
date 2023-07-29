//
//  MapView.swift
//  Client
//
//  Created by 김동락 on 2023/07/23.
//
import SwiftUI
import NMapsMap

struct MapView: View {
    @Binding var coord: (Double, Double)
    
    var body: some View {
        ZStack {
            UIMapView(coord: coord)
        }
    }
}


struct UIMapView: UIViewRepresentable {
    var coord: (Double, Double)
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 17
      
        return view
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        let coord = NMGLatLng(lat: coord.1, lng: coord.0)
        let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        uiView.mapView.moveCamera(cameraUpdate)
    }
        
}
