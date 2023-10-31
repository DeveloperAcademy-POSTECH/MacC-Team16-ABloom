//
//  QnAListItem.swift
//  ABloom
//
//  Created by yun on 10/22/23.
//

import SwiftUI

enum AnswerStatus {
  case both
  case onlyMe
  case onlyFinace
  case nobody
}

struct QnAListItem: View {
  let categoryImg: String
  let question: String
  let date: Date
  let isAns: AnswerStatus
  
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
        
        HStack(spacing: 0) {
          Text(formattedWeddingDate)
            .fontWithTracking(.caption2R)
          
          Spacer()
          
          switch isAns {
          case .onlyMe:
            Text("답변을 기다리고 있어요 >")
              .fontWithTracking(.caption2R)
          case .onlyFinace:
            Text("답변해주세요 >")
              .fontWithTracking(.caption2R)
          case .nobody, .both:
            EmptyView()
          }
        }
        .foregroundStyle(.stone500)
      }
    }
    .padding(.horizontal, 20)
  }
}
