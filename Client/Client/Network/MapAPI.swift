//
//  KakaoSearchAPI.swift
//  Client
//
//  Created by 김동락 on 2023/07/29.
//

import Foundation
import Moya

enum MapAPI {
    case searchKakao(request: SearchRequest)
}
extension MapAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .searchKakao:
            return URL(string: "https://dapi.kakao.com")!
        }
    }
    
    var path: String {
        switch self {
        case .searchKakao:
            return "/v2/local/search/keyword"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchKakao:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .searchKakao(let request):
            return .requestParameters( parameters: [
                "query": request.keyword,
                "category_group_code": "HP8",
                "x": request.longtitude,
                "y": request.latitude,
                "radius": request.radius,
                "size": 1
            ], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .searchKakao:
            let apikey = Bundle.main.infoDictionary?["KAKAO_REST_API_KEY"] ?? ""
            return [ "Authorization": "KakaoAK " +  (apikey as! String) ]
        }
    }
    
}

