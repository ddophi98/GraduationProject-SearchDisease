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
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("홈 화면")
                    }
                
                FindDiseaseView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("질병 검색")
                    }
                FindHospitalView()
                    .tabItem {
                        Image(systemName: "cross.case.fill")
                        Text("병원 검색")
                    }
            }
            .tint(.black)
        }
    }
}

struct ApplicationContext {
    private init() { }
    
    static let symptomRepository: SymptomRepository = SQLite3SymptomRepository.shared
    static let diseaseRepository: DiseaseRepository = SQLite3DiseaseRepository.shared
}
