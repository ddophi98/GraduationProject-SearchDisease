//
//  MapRepository.swift
//  Client
//
//  Created by 김동락 on 2023/07/29.
//

import Foundation
import Combine

protocol MapRepository {
    func searchPlace(request: SearchRequest) -> AnyPublisher<SearchResponse, Error>
}

class KakaoMapRepository: MapRepository {
    private let moyaProvider = MoyaWrapper<MapAPI>()
    
    public func searchPlace(request: SearchRequest) -> AnyPublisher<SearchResponse, Error> {
        moyaProvider.call(target: .searchKakao(request: request))
    }
}
