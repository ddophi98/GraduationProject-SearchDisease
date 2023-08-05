//
//  FindDiseaseView.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/30.
//

import SwiftUI

struct FindDiseaseView: View {
    @StateObject var viewModel = FindDiseaseViewModel(diseaseRepository: ApplicationContext.diseaseRepository)
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    ZStack {
                        TextField("질병을 검색하세요", text: $viewModel.searchText)
                            .frame(height: 40)
                            .padding(.horizontal)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.gray)
                                    .opacity(0.3)
                            }
                            .onSubmit {
                                viewModel.search()
                            }
                        
                        if !viewModel.searchText.isEmpty {
                            HStack {
                                Spacer()
                                Button(action: {
                                    viewModel.clear()
                                }) {
                                    Image(systemName: "x.circle.fill")
                                        .padding(.horizontal)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        viewModel.search()
                    }) {
                        HStack {
                            Text("검색")
                                .foregroundColor(.black)
                                .padding()
                        }
                    }
                    .frame(height: 40)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.systemOrange)
                    }
                }
                .padding()
                
                ScrollView {
                    ForEach(viewModel.searchDiseases) { disease in
                        NavigationLink(destination: DiseaseDetailView(disease: disease)) {
                            DiseaseEntry(disease: disease)
                        }
                    }
                    .padding()
                }

                Spacer()
            }
        }
    }
}

struct FindDiseaseView_Previews: PreviewProvider {
    static let viewModel = FindDiseaseViewModel(diseaseRepository: PreviewDiseaseRepository())
    
    static var previews: some View {
        FindDiseaseView(viewModel: viewModel)
    }
}
