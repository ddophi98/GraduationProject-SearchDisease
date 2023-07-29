//
//  FindHosputalViewModel.swift
//  Client
//
//  Created by 김동락 on 2023/07/15.
//

import Foundation
import CoreLocation
import Combine

class FindHospitalViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var coord: (Double, Double)?
    @Published var searchState: SearchState = .notStart
    @Published var foundPlaceName = ""
    private var userLocation: (Double, Double)?
    private var locationManager = CLLocationManager()
    private let mapRepository: MapRepository
    private var cancelBag = Set<AnyCancellable>()
    
    enum SearchState {
        case success, fail, notStart
    }
    
    init(mapRepository: MapRepository) {
        self.mapRepository = mapRepository
        setLocationManager()
    }
    
    func search() {
        guard let userLocation = userLocation else { return }
        let request = SearchRequest(
            keyword: searchText,
            longtitude: userLocation.0,
            latitude: userLocation.1,
            radius: 500
        )
        mapRepository.searchPlace(request: request)
            .sink { _ in

            } receiveValue: { response in
                if response.documents.isEmpty {
                    self.searchState = .fail
                    return
                } else {
                    self.searchState = .success
                }
                let place = response.documents[0]
                self.coord = (Double(place.x) ?? 0, Double(place.y) ?? 0)
                self.foundPlaceName = place.place_name
            }
            .store(in: &cancelBag)

    }
    
    func clear() {
        self.searchText = ""
    }
    
    func getUserLocation() {
        let latitude = locationManager.location?.coordinate.latitude ?? 0
        let longitude = locationManager.location?.coordinate.longitude ?? 0
        userLocation = (longitude, latitude)
        coord = userLocation
    }
    
    private func setLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
}

