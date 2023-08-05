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
                Text("증상")
                    .font(.title2)
                Spacer()
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("지난 일주일간 ")
                    + Text("\(viewModel.countSymptom(after: Date().beforeDays(7)))번")
                        .bold()
                    + Text("의 증상을 입력했습니다.")
                }
                .font(.system(size: 15))
                .padding([.top, .bottom])
                
                Spacer()
                
                NavigationLink(destination: SymptomListView(viewModel: viewModel)) {
                    Image(systemName: "chevron.right")
                }
            }
            
            VStack {
                ForEach(viewModel.getSymptoms(count: 3, after: Date().beforeDays(7))) { symptom in
                    SymptomEntry(symptom: symptom, oneLineLimit: true)
                }
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
