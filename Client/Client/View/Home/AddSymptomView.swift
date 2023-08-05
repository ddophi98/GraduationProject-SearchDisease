//
//  AddSymptomView.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/30.
//

import SwiftUI

struct AddSymptomView: View {
    @ObservedObject var viewModel: HomeViewModel
    @FocusState var focused: Bool
    
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
                .focused($focused)
            
            
            if viewModel.isInputEmpty {
                Text("한글자 이상 입력해주세요.")
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Spacer()
                Button(action: {
                    viewModel.dismissSheet()
                }) {
                    HStack {
                        Spacer()
                        Text("닫기")
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
                
                Button(action: {
                    if viewModel.inputText.isEmpty {
                        viewModel.notifyInputIsEmpty(true)
                    } else {
                        viewModel.notifyInputIsEmpty(false)
                        viewModel.addSymptom()
                    }
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
                
                Spacer()
            }
        }
        .padding()
        .onAppear {
            focused = true
        }
    }
}

struct AddSymptomView_Previews: PreviewProvider {
    static let viewModel = HomeViewModel(symptomRepository: PreviewSymptomRepository(), diseaseRepository: PreviewDiseaseRepository())
    
    static var previews: some View {
        AddSymptomView(viewModel: viewModel)
    }
}
