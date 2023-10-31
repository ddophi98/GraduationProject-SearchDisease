//
//  FindDiseaseViewModel.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/30.
//

import Foundation

class FindDiseaseViewModel: ObservableObject {
    let diseaseRepository: DiseaseRepository
    
    @Published var searchText: String = ""
    @Published var searchDiseases: [Disease] = []
    
    init(diseaseRepository: DiseaseRepository) {
        self.diseaseRepository = diseaseRepository
    }
    
    func search() {
        self.searchDiseases = diseaseRepository.findByName(name: searchText)
    }
    
    func getDepartment(disease: Disease) -> [MedicalDepartment] {
        return diseaseRepository.getDepartment(disease: disease)
    }
    
    func clear() {
        self.searchText = ""
        self.searchDiseases = []
    }
}
