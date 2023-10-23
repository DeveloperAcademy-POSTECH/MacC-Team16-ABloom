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
      // TODO: 이미지 처리 이야기 진행 
      Image(categoryImg)
        .resizable()
        .frame(width: 20, height: 20)
        .aspectRatio(contentMode: .fit)
        .background(
          RoundedRectangle(cornerRadius: 16)
            .clayMorpMDShadow()
            .foregroundStyle(.biBlue)
            .frame(width: 50, height: 50)
        )
        .frame(width: 50, height: 50)
        .padding(.trailing, 15)
      
      
      VStack(spacing: 4) {
        HStack {
          Text(question)
            .fontWithTracking(fontStyle: .caption1R)
            .foregroundStyle(.black)
          Spacer()
        }
        HStack {
          Text(date)
            .fontWithTracking(fontStyle: .caption2R)
          Spacer()
          Text(isAns ? "" : "답변을 기다리고 있어요 >")
            .fontWithTracking(fontStyle: .caption2R)
        }
        .foregroundStyle(.stone500)
      }
      Spacer()
      
    }
    .frame(width: 350, height: 50)
  }
}

#Preview {
  QnAListItem(categoryImg: "star_svg", question: "나와 결혼을 결심한 순간은 언제야?", date: "2023년 9월 18일", isAns: false)
}
