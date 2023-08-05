//
//  DiseaseEntry.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/29.
//

import SwiftUI

struct DiseaseEntry: View {
    let disease: Disease
    var rank: Int? = nil
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(rank == nil ? "" : "\(rank!). ")\(disease.name)")
                    .font(.system(size: 15))
                    .bold()
                Text(disease.definition)
                    .font(.system(size: 12))
                    .lineLimit(1)
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
        .foregroundColor(.black)
        .padding()
        .frame(height: 60)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.systemGreen)
                .opacity(0.7)
        }
    }
}

struct DiseaseEntry_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DiseaseEntry(disease: Disease(id: 1, name: "감기", definition: "감기는 감기다", cause: "추워서", symptom: "아픔", diagnosis: "기침을 하고 열이 남", cure: "푹 쉬기"), rank: 1)
            DiseaseEntry(disease: Disease(id: 1, name: "감기", definition: "감기는 감기다ㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏ", cause: "추워서", symptom: "아픔", diagnosis: "기침을 하고 열이 남", cure: "푹 쉬기"), rank: 2)
        }
    }
}
