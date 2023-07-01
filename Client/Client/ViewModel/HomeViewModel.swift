//
//  HomeViewModel.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/30.
//

import Foundation

class HomeViewModel: ObservableObject {
    private var symptomRepository: SymptomRepository
    private var diseaseRepository: DiseaseRepository
    @Published private var symptoms: [Symptom] = []
    @Published var isSheetPresented: Bool = false
    @Published var inputText: String = ""
    
    init(symptomRepository: SymptomRepository, diseaseRepository: DiseaseRepository) {
        self.symptomRepository = symptomRepository
        self.diseaseRepository = diseaseRepository
        self.symptoms = symptomRepository.findAll()
    }
    
    func hasSymptom(after: Date? = nil) -> Bool {
        let result = after == nil ? symptoms : symptoms.filter { $0.date > after! }
        return !result.isEmpty
    }
    
    func countSymptom(after: Date? = nil) -> Int {
        let result = after == nil ? symptoms : symptoms.filter { $0.date > after! }
        return result.count
    }
    
    func getSymptoms(count: Int? = nil, after: Date? = nil) -> [Symptom] {
        let result = after == nil ? symptoms : symptoms.filter { $0.date > after! }
        return count == nil ? result : Array(result.prefix(count!))
    }
    
    func addSymptom() {
        symptomRepository.create(content: inputText)
        inputText = ""
        isSheetPresented = false
        symptoms = symptomRepository.findAll()
    }
    
    func deleteSymptom(at: Int) {
        symptomRepository.delete(id: symptoms[at].id)
        symptoms = symptomRepository.findAll()
    }
    
    // TODO: 구현
    func suspectedDisease(from: Date, to: Date) -> [Disease] {
        return [
            Disease(id: 1, name: "감기", definition: "감기정의", cause: "감기원인", symptom: "감기증상", diagnosis: "감기진단", cure: "감기치료"),
            Disease(id: 2, name: "코로나", definition: "코로나정의", cause: "코로나원인", symptom: "코로나증상", diagnosis: "코로나진단", cure: "코로나치료"),
            Disease(id: 3, name: "결핵", definition: "결핵정의", cause: "결핵원인", symptom: "결핵증상", diagnosis: "결핵진단", cure: "결핵치료"),
        ]
    }
}
