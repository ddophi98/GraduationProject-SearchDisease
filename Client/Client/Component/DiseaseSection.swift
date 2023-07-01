//
//  DiseaseSection.swift
//  Client
//
//  Created by YeongWooKim on 2023/06/30.
//

import SwiftUI

struct DiseaseSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.title2)
                .bold()
            Divider()
            HStack {
                Text(content)
                Spacer()
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.systemOrange)
                    .opacity(0.3)
            }
            .padding(.bottom)
        }
    }
}

struct DiseaseSection_Previews: PreviewProvider {
    static var previews: some View {
        DiseaseSection(title: "감기", content: "감기증상")
    }
}
