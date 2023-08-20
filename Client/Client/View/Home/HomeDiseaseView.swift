//
//  HomeDiseaseView.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/30.
//

import SwiftUI

struct HomeDiseaseView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var isFirstAppeared = true
    
    var body: some View {
        VStack {
            predictedResultTitle
            if viewModel.isLoading {
                predictLoading
            } else if viewModel.predictedDiseases.isEmpty {
                predictNothing
            } else {
                predictedResult
            }
        }
        .onAppear {
            if isFirstAppeared {
                isFirstAppeared = false
                viewModel.predictDisease(from: Date().beforeDays(7), to: Date())
            }
        }
        .onChange(of: viewModel.symptoms) { _ in
            viewModel.predictDisease(from: Date().beforeDays(7), to: Date())
        }
        .onChange(of: viewModel.predictMode) { _ in
            viewModel.predictDisease(from: Date().beforeDays(7), to: Date())
        }
    }
    
    @ViewBuilder
    private var predictLoading: some View {
        Spacer()
            .frame(height: 120)
        ProgressView()
            .padding(.bottom)
        Text("의심 질환을 예상중입니다...")
            .font(.callout)
            .opacity(0.5)
        Spacer()
            .frame(height: 120)
    }
    
    @ViewBuilder
    private var predictNothing: some View {
        Spacer()
            .frame(height: 120)
        Text("증상 정보가 부족하거나 일치하는 데이터가 없습니다.")
            .font(.callout)
            .opacity(0.5)
        Spacer()
            .frame(height: 120)
    }
    
    @ViewBuilder
    private var predictedResultTitle: some View {
        HStack {
            Text("예측 질병")
                .font(.title2)
            Spacer()
            Picker("", selection: $viewModel.predictMode) {
                Text("TF-IDF").tag(PredictMode.tfidf)
                Text("ChatGPT").tag(PredictMode.chatGPT)
            }
            .pickerStyle(.segmented)
            .frame(width: 200)
        }
        
        Divider()
    }
    
    @ViewBuilder
    private var predictedResult: some View {
        
        
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

struct HomeDiseaseView_Previews: PreviewProvider {
    static let viewModel = HomeViewModel(symptomRepository: PreviewSymptomRepository(), diseaseRepository: PreviewDiseaseRepository())
    
    static var previews: some View {
        HomeDiseaseView(viewModel: viewModel)
    }
}
