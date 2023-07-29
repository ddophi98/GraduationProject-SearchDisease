//
//  Place.swift
//  Client
//
//  Created by 김동락 on 2023/07/29.
//

public struct SearchResponse: Decodable {
    let documents: [Place]
}

public struct Place: Decodable {
    let place_name: String
    let x: String
    let y: String
}
