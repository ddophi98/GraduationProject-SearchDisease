//
//  SymptomEntry.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/29.
//

import SwiftUI

struct SymptomEntry: View {
    let symptom: Symptom
    var oneLineLimit: Bool = false
    
    var body: some View {
        HStack {
            Text(symptom.content)
                .font(.system(size: 15))
                .lineLimit(oneLineLimit ? 1 : nil)
            Spacer()
            Text(daysBefore(date: symptom.date))
                .font(.system(size: 15))
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.systemOrange)
                .opacity(0.3)
        }
    }
    
    private func daysBefore(date: Date) -> String {
        switch date.getDday() {
        case 0:
            return "오늘"
        case 1:
            return "어제"
        default:
            return "\(date.getDday())일 전"
        }
    }
}

struct SymptomEntry_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SymptomEntry(symptom: Symptom(id: 1, content: "콧물이 나고 가래가 생김", date: Date()), oneLineLimit: true)
            SymptomEntry(symptom: Symptom(id: 1, content: "콧물이 나고 가래가 생김", date: Date(timeIntervalSinceNow: -Date.secondsInDay)), oneLineLimit: true)
            SymptomEntry(symptom: Symptom(id: 1, content: "콧물이 남", date: Date(timeIntervalSinceNow: -Date.secondsInDay * 3)), oneLineLimit: true)
        }
    }
}
