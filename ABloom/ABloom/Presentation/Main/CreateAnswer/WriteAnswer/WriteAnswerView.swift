//
//  WriteAnswerView.swift
//  ABloom
//
//  Created by 정승균 on 11/15/23.
//

import SwiftUI

struct WriteAnswerView: View {
  var question: DBStaticQuestion
  
  var body: some View {
    Text(question.content)
  }
}

#Preview {
  WriteAnswerView(question: .init(questionID: 1, category: "communication", content: "Hello"))
}
