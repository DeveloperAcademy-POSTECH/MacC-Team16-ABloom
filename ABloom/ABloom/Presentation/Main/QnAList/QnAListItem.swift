//
//  QnAListItem.swift
//  ABloom
//
//  Created by yun on 10/22/23.
//

import SwiftUI

struct QnAListItem: View {
  let question: DBStaticQuestion
  let date: Date
  let answerStatus: AnswerStatus
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(question.content.useNonBreakingSpace())
        .foregroundStyle(.stone900)
        .customFont(.subHeadlineB)
        .multilineTextAlignment(.leading)
      
      Text(date.formatToYMD())
        .customFont(.caption2B)
        .foregroundStyle(.gray400)
      
      HStack(spacing: 6) {
        categoryTag
        
        answerStatusTag
        
        Spacer()
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 20)
    .background(Color.white)
    .cornerRadius(12, corners: .allCorners)
  }
}

extension QnAListItem {
  private var categoryTag: some View {
    HStack {
      Text(Category(rawValue: question.category)?.type ?? "")
        .customFont(.caption2B)
        .foregroundStyle(.gray600)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
    .overlay {
      RoundedRectangle(cornerRadius: 14)
        .stroke(lineWidth: 1)
        .foregroundStyle(.gray400)
    }
  }
  
  private var answerStatusTag: some View {
    Text("\(answerStatus.text)")
      .customFont(.caption2B)
      .foregroundStyle(answerStatus.textColor)
      .padding(.horizontal, 12)
      .padding(.vertical, 6)
      .background(answerStatus.backgroundColor)
      .clipShape(RoundedRectangle(cornerRadius: 14))
      .overlay {
        if answerStatus.isStroke {
          RoundedRectangle(cornerRadius: 14)
            .stroke(lineWidth: 1)
            .foregroundStyle(.purple600)
        }
      }
  }
}

#Preview {
  ScrollView {
    let content: String = "질문입니다질 문입니다질문입니다질문입니 다질문입니 다질문입니다질문입니다질문입니다질문입니다"
    let mockDBStaticQuestion = DBStaticQuestion(questionID: 1, category: "경제", content: content)
    
    QnAListItem(question: mockDBStaticQuestion, date: .now, answerStatus: .completed)
    QnAListItem(question: mockDBStaticQuestion, date: .now, answerStatus: .onlyFinace)
    QnAListItem(question: mockDBStaticQuestion, date: .now, answerStatus: .onlyMe)
    QnAListItem(question: mockDBStaticQuestion, date: .now, answerStatus: .reactOnlyFinace)
    QnAListItem(question: mockDBStaticQuestion, date: .now, answerStatus: .reactOnlyMe)
    QnAListItem(question: mockDBStaticQuestion, date: .now, answerStatus: .moreCommunication)
    QnAListItem(question: mockDBStaticQuestion, date: .now, answerStatus: .moreResearch)
  }
  .background(Color.blue)
}
