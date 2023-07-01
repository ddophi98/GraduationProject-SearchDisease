//
//  HomeSymptomView.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/30.
//

import SwiftUI

struct HomeSymptomView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("지난 일주일간 ")
                    + Text("\(viewModel.countSymptom(after: Date().beforeDays(7)))번")
                        .font(.title3)
                        .bold()
                    + Text("의 증상이 있었습니다.")
                }
                Spacer()
            }
            
            VStack {
                ForEach(viewModel.getSymptoms(count: 3, after: Date().beforeDays(7))) { symptom in
                    SymptomEntry(symptom: symptom, oneLineLimit: true)
                }
                
                NavigationLink(destination: SymptomListView(viewModel: viewModel)) {
                    HStack {
                        Text("더보기")
                            .foregroundColor(.black)
                    }
                    .frame(width: 100, height: 30)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.systemOrange)
                            .opacity(0.3)
                    }
                }
                .padding(.top)
            }
            .padding(.bottom)
        }
    }
}

struct HomeSymptomView_Previews: PreviewProvider {
    static let viewModel = HomeViewModel(symptomRepository: PreviewSymptomRepository(), diseaseRepository: PreviewDiseaseRepository())
    
    static var previews: some View {
        HomeSymptomView(viewModel: viewModel)
    }
}
