//
//  HospitalView.swift
//  Client
//
//  Created by 김동락 on 2023/07/15.
//

import SwiftUI

struct FindHospitalView: View {
    @StateObject var viewModel = FindHospitalViewModel(mapRepository: KakaoMapRepository())
    
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
                
                if viewModel.searchState == .fail {
                    Divider()
                    HStack {
                        Text("주변에")
                        Text(viewModel.searchText)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        Text("는(은) 없습니다.")
                    }
                    .padding([.leading, .trailing])
                    Divider()
                } else if viewModel.searchState == .success {
                    Divider()
                    HStack {
                        Text("해당 위치에")
                        Text(viewModel.foundPlaceName)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        Text("가(이) 있습니다.")
                    }
                    .padding([.leading, .trailing])
                    Divider()
                }
                
                MapView(coord: $viewModel.coord.toUnwrapped(defaultValue: (0, 0)))
            }
        }
        .onAppear {
            viewModel.getUserLocation()
        }
        .onChange(of: viewModel.searchText) { _ in
            viewModel.searchState = .notStart
        }
    }
}

struct FindHospitalView_Previews: PreviewProvider {
    static var previews: some View {
        FindHospitalView()
    }
}
