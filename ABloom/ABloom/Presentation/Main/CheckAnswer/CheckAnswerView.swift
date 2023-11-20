//
//  CheckAnswerView.swift
//  ABloom
//
//  Created by 정승균 on 11/15/23.
//

import SwiftUI

struct CheckAnswerView: View {
  let question: DBStaticQuestion
  let date: Date = .now
  let myAnswer: DBAnswer = DBAnswer(questionId: 1, userId: "dd", answerContent: "대답", isComplete: false, reaction: nil)
  let fianceAnswer: DBAnswer = DBAnswer(questionId: 1, userId: "dd", answerContent: "대답이다", isComplete: false, reaction: nil)
  let currentUserName: String = "이름"
  let fianceName: String = "상대방이름"
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 40) {
        questionArea
        
        myAnswerArea
        
        fianceAnswerArea
        
        reactionArea
      }
      .frame(maxWidth: .infinity)
      .multilineTextAlignment(.leading)
    }
    .padding(.horizontal, 20)
    .background(Color.gray100) // background(Color.Background)
  }
}

extension CheckAnswerView {
  private var questionArea: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text(question.content.useNonBreakingSpace())
        .customFont(.headlineB)
      Text("\(date)")
        .customFont(.caption2R)
        .foregroundStyle(.gray500)
    }
  }
  private var myAnswerArea: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("\(currentUserName)님의 대답")
        .customFont(.calloutB)
      Text(myAnswer.answerContent.useNonBreakingSpace())
        .customFont(.footnoteR)
        .foregroundStyle(.gray500)
    }
  }
  
  private var fianceAnswerArea: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("\(fianceName)님의 대답")
        .customFont(.calloutB)
      Text(fianceAnswer.answerContent.useNonBreakingSpace())
        .customFont(.footnoteR)
        .foregroundStyle(.gray500)
    }
  }
  
  private var reactionArea: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("우리의 반응")
        .customFont(.calloutB)
      Text("둘 다 답변을 작성하면 우리만의 반응을 추가할 수 있어요.")
        .customFont(.footnoteR)
        .foregroundStyle(.gray500)
    }
  }
}

#Preview {
  CheckAnswerView(question: DBStaticQuestion(questionID: 1, category: "경제", content: "question"))
}
