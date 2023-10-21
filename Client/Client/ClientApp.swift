//
//  ClientApp.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/25.
//

import SwiftUI

@main
struct ClientApp: App {
    var body: some Scene {
        WindowGroup {
            InitialView()
        }
    }
}

struct ApplicationContext {
    private init() { }
    
    static let symptomRepository: SymptomRepository = SQLite3SymptomRepository.shared
    static let diseaseRepository: DiseaseRepository = SQLite3DiseaseRepository.shared
}
