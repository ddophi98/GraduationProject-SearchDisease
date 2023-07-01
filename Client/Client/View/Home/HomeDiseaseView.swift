//
//  HomeDiseaseView.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/30.
//

import SwiftUI

struct HomeDiseaseView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            let diseases = viewModel.suspectedDisease(from: Date().beforeDays(7), to: Date().beforeDays(0))
            
            HStack {
                VStack(alignment: .leading) {
                    Text("해당 증상을 바탕으로")
                    Text("가장 의심되는 질병은 ")
                    + Text("\(diseases.first?.name ?? "")")
                        .font(.title3)
                        .bold()
                    + Text("입니다.")
                }
                Spacer()
            }
            
            VStack {
                ForEachWithIndex(data: diseases) { index, disease in
                    NavigationLink(destination: DiseaseDetailView(disease: disease)) {
                        DiseaseEntry(disease: disease, rank: index + 1)
                    }
                }
            }
        }
    }
}

struct HomeDiseaseView_Previews: PreviewProvider {
    static let viewModel = HomeViewModel(symptomRepository: PreviewSymptomRepository(), diseaseRepository: PreviewDiseaseRepository())
    
    static var previews: some View {
        HomeDiseaseView(viewModel: viewModel)
    }
}