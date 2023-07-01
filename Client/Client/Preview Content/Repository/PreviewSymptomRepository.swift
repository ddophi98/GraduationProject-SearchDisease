//
//  PreviewSymptomRepository.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/30.
//

import Foundation

class PreviewSymptomRepository: SymptomRepository {
    static var shared: SymptomRepository = PreviewSymptomRepository()
    
    func create(content: String) {}
    
    func findAll() -> [Symptom] {
        return [
            Symptom(id: 3, content: "아프다", date: Date()),
            Symptom(id: 2, content: "아프다ㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏ", date: Date(timeIntervalSinceNow: -Date.secondsInDay)),
            Symptom(id: 1, content: "으악", date: Date(timeIntervalSinceNow: -Date.secondsInDay * 5)),
        ]
    }
    
    func update(id: Int, content: String) {}
    
    func delete(id: Int) {}
}
