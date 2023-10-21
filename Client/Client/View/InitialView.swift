//
//  GetUserInfoView.swift
//  Client
//
//  Created by 김동락 on 10/21/23.
//

import SwiftUI

struct InitialView: View {
    
    @StateObject var viewModel = GetUserInfoViewModel()
    @State var tag:Int? = nil
    
    var body: some View {
        if viewModel.isUserInfoExist() {
            tabView
        } else {
            getUserInfoView
        }
    }
    
    @ViewBuilder
    private var getUserInfoView: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("정확한 검진을 위해 사용자 정보를 입력받습니다.")
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                inputField(input: $viewModel.age, message: "나이를 입력해주세요.", unit: "세")
                inputField(input: $viewModel.height, message: "키를 입력해주세요.", unit: "cm")
                inputField(input: $viewModel.weight, message: "몸무게를 입력해주세요.", unit: "kg")
                
                VStack {
                    Text("성별을 골라주세요.")
                    Picker("원하는 색을 골라주세요", selection: $viewModel.gender) {
                        Text("남자")
                            .tag("남자")
                        Text("여자").tag("여자")
                    }
                    .frame(width: 120)
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                NavigationLink(destination: tabView) {
                    HStack {
                        Spacer()
                        Text("시작하기")
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
            .padding()
            .onDisappear {
                viewModel.saveUserInfo()
            }
        }
    }
    
    @ViewBuilder
    private var tabView: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("홈 화면")
                }
            
            FindDiseaseView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("질병 검색")
                }
            FindHospitalView()
                .tabItem {
                    Image(systemName: "cross.case.fill")
                    Text("병원 검색")
                }
        }
        .tint(.black)
        .navigationBarBackButtonHidden()
    }
    
    @ViewBuilder
    private func inputField(input: Binding<String>, message: String, unit: String) -> some View {
        VStack {
            Text(message)
            HStack {
                Text(unit)
                    .opacity(0)
                TextField("", text: input)
                    .frame(width: 100)
                    .padding(8)
                    .multilineTextAlignment(.center)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    }
                Text(unit)
            }
        }
    }
}

#Preview {
    InitialView()
}
