//
//  DiseaseDetailView.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/30.
//

import SwiftUI

struct DiseaseDetailView: View {
    let disease: Disease
    
    var body: some View {
        VStack {
            ScrollView {
                DiseaseSection(title: "정의", content: disease.definition)
                DiseaseSection(title: "원인", content: disease.cause)
                DiseaseSection(title: "증상", content: disease.symptom)
                DiseaseSection(title: "진단", content: disease.diagnosis)
                DiseaseSection(title: "치료", content: disease.cure)
                Spacer()
            }
            
            Button(action: {}) {
                HStack {
                    Spacer()
                    Text("병원 검색")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.black)
                    Spacer()
                }
            }
            .frame(height: 50)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.systemOrange)
            }
        }
        .padding()
        .navigationTitle(disease.name)
    }
}

struct DiseaseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DiseaseDetailView(disease: Disease(id: 1, name: "감기", definition: "감기정의", cause: "감기원인", symptom: "감기증상", diagnosis: "감기진단", cure: "감기치료"))
    }
}
