//
//  HomeView.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel(symptomRepository: ApplicationContext.symptomRepository, diseaseRepository: ApplicationContext.diseaseRepository)
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    if viewModel.hasSymptom(after: Date().beforeDays(7)) {
                        HomeSymptomView(viewModel: viewModel)
                        HomeDiseaseView(viewModel: viewModel)
                    } else {
                        Spacer()
                        HomeEmptySymptomView()
                        Button {
                            viewModel.suspectedDisease(from: Date(), to: Date())
                        } label: {
                            Text("predict")
                        }

                    }
                    Spacer()
                }
                .padding()
                
                HomeAddSymptomView(viewModel: viewModel)
                    .padding()
            }
            .padding(.bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let viewModel = HomeViewModel(symptomRepository: PreviewSymptomRepository(), diseaseRepository: PreviewDiseaseRepository())
    
    static var previews: some View {
        HomeView(viewModel: viewModel)
    }
}

