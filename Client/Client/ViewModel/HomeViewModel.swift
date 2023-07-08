//
//  HomeViewModel.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/30.
//

import Foundation
import ChatGPTSwift

class HomeViewModel: ObservableObject {
    private var symptomRepository: SymptomRepository
    private var diseaseRepository: DiseaseRepository
    @Published private var symptoms: [Symptom] = []
    @Published var isSheetPresented: Bool = false
    @Published var inputText: String = ""
    @Published var predictedDiseases = [Disease]()
    
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
    func suspectedDisease(from: Date, to: Date) {
        let filtered = symptoms.filter{ (from...to).contains($0.date) }
        return predictWithChatGPT(symptoms: filtered)
    }
    
    // 직접 만든 TF-IDF 파일에서 단어 가중치 계산해서 질병 예측하기
    private func predictWithVerctorization(symptoms: [Symptom]) {
        var sentence = ""
        for symptom in symptoms {
            sentence.append(symptom.content)
        }
        
        // TODO: .
        // 1. vectorization 데이터 가져오기
        // 2. 각 질병마다 값이 0이 아닌 속성(단어)이 sentence에 있는지 확인하기
        // 3. 있다면 해당 값을 더하기
        // 4. 더한 값이 가장 높은 상위 3개 질병 반환
        
        predictedDiseases = [
            Disease(id: 1, name: "감기", definition: "감기정의", cause: "감기원인", symptom: "감기증상", diagnosis: "감기진단", cure: "감기치료"),
            Disease(id: 2, name: "코로나", definition: "코로나정의", cause: "코로나원인", symptom: "코로나증상", diagnosis: "코로나진단", cure: "코로나치료"),
            Disease(id: 3, name: "결핵", definition: "결핵정의", cause: "결핵원인", symptom: "결핵증상", diagnosis: "결핵진단", cure: "결핵치료"),
        ]
    }
    
    // https://github.com/alfianlosari/ChatGPTSwift?ref=iosexample.com
    // ChatGPT한테 증상 물어보고 질병 예측하기
    private func predictWithChatGPT(symptoms: [Symptom]) {
        let api = ChatGPTAPI(apiKey: "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")
        
        var sentence = ""
        for symptom in symptoms {
            sentence.append(symptom.content + "\n")
        }
        
        let question = sentence + "앞서 말한 것들은 요즘 내가 느끼는 증상이야. 내가 가지고 있을만한 질병을 세가지 예측해줘. 질병들은 숫자와 콜론을 이용해서 각각 알려줘"
        
        Task {
            do {
                let response = try await api.sendMessage(text: question)
                print(response)
                let colonIndexs = response.findAll(str: ":")
                for i in 0..<colonIndexs.count {
                    let numIndex = response.findAll(str: String(i))[0]
                    let diseaseName = response.substring(from: numIndex+3, to: colonIndexs[i])
                    // TODO: 포함여부로 바꾸기, 없을 때 처리
                    let disease = diseaseRepository.findByName(name: diseaseName)
                    predictedDiseases.append(contentsOf: disease)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
