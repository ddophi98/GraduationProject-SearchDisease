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
        if viewModel.predictedDiseases.isEmpty {
            VStack {
                Spacer()
                    .frame(height: 120)
                ProgressView()
                Text("의심 질환을 예상중입니다...")
                    .font(.callout)
                    .opacity(0.5)
                Spacer()
                    .frame(height: 120)
            }
            .onAppear {
                viewModel.predictDisease(from: Date().beforeDays(7), to: Date())
            }
        } else {
            VStack {
                HStack {
                    Text("예측 질병")
                        .font(.title2)
                    Spacer()
                }
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("해당 증상을 바탕으로 가장 의심되는 질병은 ")
                        + Text("\(viewModel.predictedDiseases.first?.name ?? "")")
                            .bold()
                        + Text("입니다.")
                    }
                    .font(.system(size: 15))
                    .padding([.top, .bottom])
                    
                    Spacer()
                }
                
                VStack {
                    ForEachWithIndex(data: viewModel.predictedDiseases) { index, disease in
                        NavigationLink(destination: DiseaseDetailView(disease: disease)) {
                            DiseaseEntry(disease: disease, rank: index + 1)
                        }
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
