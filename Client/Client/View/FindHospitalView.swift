//
//  HospitalView.swift
//  Client
//
//  Created by 김동락 on 2023/07/15.
//

import SwiftUI

struct FindHospitalView: View {
    @StateObject var viewModel = FindHospitalViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    ZStack {
                        TextField("병원을 검색하세요", text: $viewModel.searchText)
                            .frame(height: 40)
                            .padding(.horizontal)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.gray)
                                    .opacity(0.3)
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
                Spacer()
            }
        }
    }
}

struct FindHospitalView_Previews: PreviewProvider {
    static var previews: some View {
        FindHospitalView()
    }
}
