//
//  FindHosputalViewModel.swift
//  Client
//
//  Created by 김동락 on 2023/07/15.
//

import Foundation

class FindHospitalViewModel: ObservableObject {
    @Published var searchText: String = ""
    
    func search() {
        
    }
    
    func clear() {
        self.searchText = ""
    }
}

