//
//  SymptomListView.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/30.
//

import SwiftUI

struct SymptomListView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.getSymptoms()) { symptom in
                    SymptomEntry(symptom: symptom)
                        .listRowInsets(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                }
                .onDelete { indexSet in
                    for idx in indexSet {
                        viewModel.deleteSymptom(at: idx)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            Spacer()
        }
        .navigationTitle("나의 기록")
    }
}

struct SymptomListView_Previews: PreviewProvider {
    static let viewModel = HomeViewModel(symptomRepository: PreviewSymptomRepository(), diseaseRepository: PreviewDiseaseRepository())
    
    static var previews: some View {
        SymptomListView(viewModel: viewModel)
    }
}
