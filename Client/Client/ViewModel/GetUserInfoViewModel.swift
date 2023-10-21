//
//  GetUserInfoViewModel.swift
//  Client
//
//  Created by 김동락 on 10/21/23.
//

import Foundation

class GetUserInfoViewModel: ObservableObject {
    @Published var age: String = ""
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var gender: String = ""

    func saveUserInfo() {
        UserDefaults.standard.setValue(age, forKey: "age")
        UserDefaults.standard.setValue(height, forKey: "height")
        UserDefaults.standard.setValue(weight, forKey: "weight")
        UserDefaults.standard.setValue(gender, forKey: "gender")
    }
    
    func isUserInfoExist() -> Bool {
        if UserDefaults.standard.string(forKey: "age") != nil &&
            UserDefaults.standard.string(forKey: "height") != nil &&
            UserDefaults.standard.string(forKey: "weight") != nil &&
            UserDefaults.standard.string(forKey: "gender") != nil {
            return true
        }
        return false
    }
}
