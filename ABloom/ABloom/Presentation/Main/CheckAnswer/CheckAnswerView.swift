//
//  CheckAnswerView.swift
//  ABloom
//
//  Created by 정승균 on 11/15/23.
//

import SwiftUI

struct CheckAnswerView: View {
  let question: DBStaticQuestion
  var body: some View {
    Text(question.content)
  }
}

#Preview {
  CheckAnswerView(question: DBStaticQuestion(questionID: 1, category: "경제", content: "질문"))
}
