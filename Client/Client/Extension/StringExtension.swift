//
//  StringExtension.swift
//  Client
//
//  Created by 김동락 on 2023/07/08.
//

extension String {
    func findAll(str: String) -> [Int] {
        var indexs = [Int]()
        for i in 0..<self.count-str.count {
            if  substring(from: i, to: i+str.count) == str {
                indexs.append(i)
            }
        }
        return indexs
    }
    
    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }
        
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1) //
        
        return String(self[startIndex ..< endIndex])
    }
}
