//
//  QnAListItem.swift
//  ABloom
//
//  Created by yun on 10/22/23.
//

import SwiftUI

struct QnAListItem: View {
  let categoryImg: String
  let question: String
  let date: Date
  let isAns: Bool
  
  var formattedWeddingDate: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 MM월 dd일"
    return formatter.string(from: date)
  }
  
  var body: some View {
    HStack(spacing: 15) {
      
      Image(categoryImg)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 50, height: 50)
        .background(
          RoundedRectangle(cornerRadius: 17)
            .clayMorpMDShadow()
            .foregroundStyle(.white)
        )
      
      VStack(spacing: 4) {
        HStack {
          Text(question)
            .fontWithTracking(.caption1Bold)
            .foregroundStyle(.black)
            .lineLimit(1)
          
          Spacer()
        }
        HStack {
          Text(formattedWeddingDate)
            .fontWithTracking(.caption2R)
          
          Spacer()
          
          Text(isAns ? "" : "답변을 기다리고 있어요 >")
            .fontWithTracking(.caption2R)
        }
        .foregroundStyle(.stone500)
      }
      Spacer()
    }
    .padding(.horizontal, 20)
  }
}

#Preview {
  QnAListItem(categoryImg: "squareIcon_isometric_health", question: "나와 결혼을 결심한 순간은 언제야?", date: .now, isAns: false)
}
