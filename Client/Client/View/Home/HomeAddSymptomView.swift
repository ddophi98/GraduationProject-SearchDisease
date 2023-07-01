//
//  HomeAddSymptomView.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/30.
//

import SwiftUI

struct HomeAddSymptomView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("새로운 증상이 있으신가요?")
                Spacer()
            }
            
            Button(action: {
                viewModel.isSheetPresented.toggle()
            }) {
                HStack {
                    Spacer()
                    Text("증상 추가하기")
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
        .sheet(isPresented: $viewModel.isSheetPresented) {
            AddSymptomView(viewModel: viewModel)
        }
    }
}

struct HomeAddSymptomView_Previews: PreviewProvider {
    static let viewModel = HomeViewModel(symptomRepository: PreviewSymptomRepository(), diseaseRepository: PreviewDiseaseRepository())
    
    static var previews: some View {
        HomeAddSymptomView(viewModel: viewModel)
    }
}
