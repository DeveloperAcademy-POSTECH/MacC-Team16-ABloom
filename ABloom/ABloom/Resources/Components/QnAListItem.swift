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
  let date: String
  let isAns: Bool
  
  var body: some View {
    HStack(spacing: 0) {
      
      Image(categoryImg)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 50, height: 50)
        .background(
          RoundedRectangle(cornerRadius: 17)
            .clayMorpMDShadow()
            .foregroundStyle(.white)
        )
        .padding(.trailing, 15)
      
      VStack(spacing: 4) {
        HStack {
          Text(question)
            .fontWithTracking(.caption1Bold)
            .foregroundStyle(.black)
          
          Spacer()
        }
        
        HStack {
          Text(date)
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
  QnAListItem(categoryImg: "squareIcon_isometric_health", question: "나와 결혼을 결심한 순간은 언제야?", date: "2023년 9월 18일", isAns: false)
}
