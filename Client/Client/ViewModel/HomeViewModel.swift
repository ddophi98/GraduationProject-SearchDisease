//
//  HomeViewModel.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/30.
//

import Foundation
import ChatGPTSwift


enum PredictMode {
    case chatGPT
    case tfidf
    case both
}

class HomeViewModel: ObservableObject {
    private var symptomRepository: SymptomRepository
    private var diseaseRepository: DiseaseRepository
    @Published var symptoms = [Symptom]()
    @Published var isSheetPresented: Bool = false
    @Published var inputText: String = ""
    @Published var predictedDiseases = [Disease]()
    @Published var isInputEmpty = false
    @Published var predictMode: PredictMode = .tfidf
    @Published var isLoading: Bool = false
    
    init(symptomRepository: SymptomRepository, diseaseRepository: DiseaseRepository) {
        self.symptomRepository = symptomRepository
        self.diseaseRepository = diseaseRepository
        self.symptoms = symptomRepository.findAll()
    }
    
    func notifyInputIsEmpty(_ isTrue: Bool) {
        if isTrue {
            isInputEmpty = true
        } else {
            isInputEmpty = false
        }
    }
    
    func dismissSheet() {
        isSheetPresented = false
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
    
    func predictDisease(from: Date, to: Date) {
        if isLoading {
            return
        }
        
        isLoading = true
        predictedDiseases = []
        let filtered = symptoms.filter{ (from...to).contains($0.date) }
        
        switch predictMode {
        case .tfidf:
            predictWithVerctorization(symptoms: filtered)
        case .chatGPT:
            predictWithChatGPT(symptoms: filtered)
        case .both:
            predictWithBoth(symptoms: filtered)
        }
        //predictWithTestData()
    }
    
    // 테스트용
    private func predictWithTestData() {
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            self.predictedDiseases = [
                Disease(id: 1, name: "감기", definition: "감기정의", cause: "감기원인", symptom: "감기증상", diagnosis: "감기진단", cure: "감기치료"),
                Disease(id: 2, name: "코로나", definition: "코로나정의", cause: "코로나원인", symptom: "코로나증상", diagnosis: "코로나진단", cure: "코로나치료"),
                Disease(id: 3, name: "결핵", definition: "결핵정의", cause: "결핵원인", symptom: "결핵증상", diagnosis: "결핵진단", cure: "결핵치료"),
            ]
            self.isLoading = false
        }
    }
    
    // 직접 만든 TF-IDF 파일에서 단어 가중치 계산해서 질병 예측하기
    private func predictWithVerctorization(symptoms: [Symptom]) {
        let domain = "http://13.124.149.125:5000/diseases/predict?symptoms="
        let symptomString = symptoms
            .map { $0.content }
            .joined(separator: ",")
        guard let urlEncoded = (domain + symptomString).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: urlEncoded)!

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let dataString = String(data: data, encoding: .utf8)!
                print("[tfidf answer]\n", dataString)
                
                let diseases = dataString
                    .substring(from: 1, to: dataString.count - 2)
                    .replacingOccurrences(of: " ", with: "")
                    .replacingOccurrences(of: "\n", with: "")
                    .split(separator: ",")
                    .compactMap { diseaseRepository.findById(id: Int($0)!) ?? nil }
                
                updataPredictedDiseases(diseases: diseases)
            } catch {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    // https://github.com/alfianlosari/ChatGPTSwift?ref=iosexample.com
    // ChatGPT한테 증상 물어보고 질병 예측하기
    private func predictWithChatGPT(symptoms: [Symptom]) {
        let apikey = Bundle.main.infoDictionary?["CHAT_GPT_API_KEY"] ?? ""
        let api = ChatGPTAPI(apiKey: apikey as! String)
        
        var sentence = ""
        for symptom in symptoms {
            sentence.append(symptom.content + "\n")
        }
        
        let age = UserDefaults.standard.string(forKey: "age")!
        let height = UserDefaults.standard.string(forKey: "height")!
        let weight = UserDefaults.standard.string(forKey: "weight")!
        let gender = UserDefaults.standard.string(forKey: "gender")!
        
        let question = "내 나이는 \(age)살 이고, 키는 \(height)cm 이고, 몸무게는 \(weight)kg 이고, 성별은 \(gender)야.\n" +
                        "아래에 말하는 것들은 요즘 내가 느끼는 증상이야. 내가 가지고 있을만한 질병을 다섯가지 예측해줘. 질병들은 1. 감기:, 2. 독감: 형식으로 각각 알려줘\n\n" +
                        sentence
        print(question)
        
        Task {
            do {
                let response = try await api.sendMessage(text: question)
                print("[gpt answer]\n", response)
                let colonIndexs = response.findAll(str: ":")
                var totalDiseases = [Disease]()
                for i in 0..<colonIndexs.count {
                    let numIndex = response.findAll(str: String(i+1))[0]
                    let diseaseName = response.substring(from: numIndex+3, to: colonIndexs[i])
                    let disease = diseaseRepository.findByName(name: diseaseName)
                    totalDiseases.append(contentsOf: disease)
                }
                updataPredictedDiseases(diseases: totalDiseases)
            } catch {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    private func predictWithBoth(symptoms: [Symptom]) {
        let domain = "http://13.124.149.125:5000/diseases/predict?symptoms="
        let symptomString = symptoms
            .map { $0.content }
            .joined(separator: ",")
        guard let urlEncoded = (domain + symptomString).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: urlEncoded)!
        
        let apikey = Bundle.main.infoDictionary?["CHAT_GPT_API_KEY"] ?? ""
        let api = ChatGPTAPI(apiKey: apikey as! String)
        var sentence = ""
        for symptom in symptoms {
            sentence.append(symptom.content + "\n")
        }
        let symptomsWithOneSentence = sentence
        let age = UserDefaults.standard.string(forKey: "age")!
        let height = UserDefaults.standard.string(forKey: "height")!
        let weight = UserDefaults.standard.string(forKey: "weight")!
        let gender = UserDefaults.standard.string(forKey: "gender")!

        Task {
            do {
                // TF-IDF 먼저
                let (data, _) = try await URLSession.shared.data(from: url)
                let dataString = String(data: data, encoding: .utf8)!
                print("[tfidf answer]\n", dataString)
                
                let diseases = dataString
                    .substring(from: 1, to: dataString.count - 2)
                    .replacingOccurrences(of: " ", with: "")
                    .replacingOccurrences(of: "\n", with: "")
                    .split(separator: ",")
                    .compactMap { diseaseRepository.findById(id: Int($0)!) ?? nil }
                
                
                let question = "내 나이는 \(age)살 이고, 키는 \(height)cm 이고, 몸무게는 \(weight)kg 이고, 성별은 \(gender)야.\n" +
                                "아래에 말하는 것들은 요즘 내가 느끼는 증상이야.\n\n" +
                                symptomsWithOneSentence +
                                "\n이 증상들이 느껴질 때 아래 질병들을 의심할만한지 알려줘.\n" +
                                diseases.map{$0.name}.joined(separator: ", ") +
                                "\n\n각각의 질병에 대해 가능성이 높다면 1로, 가능성이 낮다면 0으로 해서 세자리 이진수로 반환해줘. 예를 들어 0b001 같이 알려줘."
                print(question)
                
                let response = try await api.sendMessage(text: question)
                print("[gpt answer]\n", response)
                
                var totalDiseases = [Disease]()
                
                if !response.findAll(str: "0b").isEmpty {
                    let binIndex = response.findAll(str: "0b")[0]
                    let binValue = response.substring(from: binIndex+2, to: binIndex+5)
                    print(binValue)
                    for (i, v) in binValue.enumerated() {
                        if v == "1" {
                            totalDiseases.append(diseases[i])
                        }
                    }
                }
                
                updataPredictedDiseases(diseases: totalDiseases)

            } catch {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    private func updataPredictedDiseases(diseases: [Disease]) {
        DispatchQueue.main.async {
            if diseases.count >= 3 {
                self.predictedDiseases = Array(diseases[0..<3])
            } else {
                self.predictedDiseases = diseases
            }
        }
    }
    
    func getDepartment(disease: Disease) -> [MedicalDepartment] {
        return diseaseRepository.getDepartment(disease: disease)
    }
}
