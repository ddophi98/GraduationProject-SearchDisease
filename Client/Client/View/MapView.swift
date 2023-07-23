//
//  MapView.swift
//  Client
//
//  Created by 김동락 on 2023/07/23.
//
import SwiftUI
import NMapsMap

struct MapView: View {
    var body: some View {
        ZStack {
            UIMapView()
        }
    }
}


struct UIMapView: UIViewRepresentable {
    func makeUIView(context: Context) -> NMFNaverMapView {
        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 17
      
        return view
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {}
}
