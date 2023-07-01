//
//  Disease.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/25.
//

import Foundation

struct Disease: Identifiable, Hashable {
    let id: Int
    let name: String
    let definition: String
    let cause: String
    let symptom: String
    let diagnosis: String
    let cure: String
}
