//
//  PreviewDiseaseRepository.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/30.
//

import Foundation

class PreviewDiseaseRepository: DiseaseRepository {
    static var shared: DiseaseRepository = PreviewDiseaseRepository()
    
    func findByName(name: String) -> [Disease] {
        return [
            Disease(id: 1, name: "감기", definition: "감기정의", cause: "감기원인", symptom: "감기증상", diagnosis: "감기진단", cure: "감기치료"),
            Disease(id: 2, name: "코로나", definition: "코로나정의", cause: "코로나원인", symptom: "코로나증상", diagnosis: "코로나진단", cure: "코로나치료"),
            Disease(id: 3, name: "결핵", definition: "결핵정의", cause: "결핵원인", symptom: "결핵증상", diagnosis: "결핵진단", cure: "결핵치료"),
        ]
    }
    
    func getSuspectedDisease(from: Date, to: Date) -> [Disease] {
        return [
            Disease(id: 1, name: "감기", definition: "감기정의", cause: "감기원인", symptom: "감기증상", diagnosis: "감기진단", cure: "감기치료"),
            Disease(id: 2, name: "코로나", definition: "코로나정의", cause: "코로나원인", symptom: "코로나증상", diagnosis: "코로나진단", cure: "코로나치료"),
            Disease(id: 3, name: "결핵", definition: "결핵정의", cause: "결핵원인", symptom: "결핵증상", diagnosis: "결핵진단", cure: "결핵치료"),
        ]
    }
}
