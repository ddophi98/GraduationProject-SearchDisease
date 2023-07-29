//
//  MoyaWrapper.swift
//  Client
//
//  Created by 김동락 on 2023/07/29.
//

import Foundation
import Combine
import Moya

class MoyaWrapper<Provider: TargetType>: MoyaProvider<Provider> {
    func call<Value>(target: Provider) -> AnyPublisher<Value, Error> where Value: Decodable {
        return self.requestPublisher(target)
            .map(Value.self)
            .catch({ moyaError -> Fail in
                return Fail(error: moyaError as Error)
            })
                .eraseToAnyPublisher()
    }
}
