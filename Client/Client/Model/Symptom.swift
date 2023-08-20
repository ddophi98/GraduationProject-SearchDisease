//
//  Symptom.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/26.
//

import Foundation

struct Symptom: Identifiable, Equatable {
    let id: Int
    let content: String
    let date: Date
}
