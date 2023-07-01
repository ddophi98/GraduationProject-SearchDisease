//
//  AddSymptomView.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/30.
//

import SwiftUI

struct AddSymptomView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("증상을 작성해주세요")
                    .font(.title3)
                Spacer()
            }
            .padding(.top)
            
            TextEditor(text: $viewModel.inputText)
                .frame(height: 200)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                }
            
            Spacer()
            
            Button(action: {
                viewModel.addSymptom()
            }) {
                HStack {
                    Spacer()
                    Text("작성 완료")
                        .font(.title3)
                        .fontWeight(.bold)
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
    }
}

struct AddSymptomView_Previews: PreviewProvider {
    static let viewModel = HomeViewModel(symptomRepository: PreviewSymptomRepository(), diseaseRepository: PreviewDiseaseRepository())
    
    static var previews: some View {
        AddSymptomView(viewModel: viewModel)
    }
}
