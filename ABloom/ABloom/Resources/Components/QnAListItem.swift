//
//  QnAListItem.swift
//  ABloom
//
//  Created by yun on 10/22/23.
//

import SwiftUI

struct QnAListItem: View {
  let category: Category
  let question: String
  let answerStatus: AnswerStatus
  
  var body: some View {
    VStack(alignment: .leading, spacing: 15) {
      HStack {
        Text("     " + question)
          .foregroundStyle(.stone900)
          .fontWithTracking(.footnoteB, lineSpacing: 2)
          .overlay(alignment: .topLeading) {
            Text("Q.")
              .foregroundColor(.purple700)
              .fontWithTracking(.subHeadlineB)
              .offset(y: -2)
          }
      }
      .multilineTextAlignment(.leading)
      
      HStack(spacing: 6) {
        categoryTag
        
        answerStatusTag
        
        Spacer()
      }
    }
    .padding(.horizontal, 25)
    .padding(.vertical, 24)
    .background(Color.white)
    .cornerRadius(12, corners: .allCorners)
  }
}

extension QnAListItem {
  private var categoryTag: some View {
    HStack {
      Text("\(category.type)")
        .fontWithTracking(.caption2R)
        .foregroundStyle(.stone600)
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
    }
    .overlay {
      RoundedRectangle(cornerRadius: 12)
        .stroke(lineWidth: 1)
        .foregroundStyle(.stone600)
    }
  }
  
  private var answerStatusTag: some View {
    HStack(spacing: 0) {
      if let image = answerStatus.image {
        image
      }
     
      Text("\(answerStatus.text)")
    }
    .fontWithTracking(.caption2R, tracking: -0.4)
    .foregroundStyle(answerStatus.textColor)
    .padding(.horizontal, 8)
    .padding(.vertical, 5)
    .background(answerStatus.backgroundColor)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .overlay {
      if answerStatus == .completed {
        RoundedRectangle(cornerRadius: 12)
          .stroke(lineWidth: 1)
          .foregroundStyle(.purple500)
      }
    }
  }
}

#Preview {
  VStack {
    QnAListItem(category: .future, question: "Nobody", answerStatus: .nobody)
    QnAListItem(category: .child, question: "onlyMe", answerStatus: .onlyMe)
    QnAListItem(category: .child, question: "onlyFinace", answerStatus: .onlyFinace)
    QnAListItem(category: .child, question: "both", answerStatus: .both)
    QnAListItem(category: .child, question: "completed", answerStatus: .completed)
  }
  .background(.blue)
}
