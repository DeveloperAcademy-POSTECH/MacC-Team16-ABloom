//
//  QuestionWriteView.swift
//  ABloom
//
//  Created by yun on 10/25/23.
//

import SwiftUI

struct AnswerWriteView: View {
  var question: DBStaticQuestion
  @StateObject var answerVM = AnswerWriteViewModel()
  
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    VStack(spacing: 13) {
      
      Spacer().frame(height: 17)
      
      questionText
      
      HStack {
        Spacer()
        
        BlueChatBubbleTextField(text: $answerVM.answerText)
          .padding(.horizontal, 22)
      }
    }
    // 네비게이션바
    .customNavigationBar(
      centerView: {
        Text("문답 작성하기")
          .fontWithTracking(.title3R)
          .foregroundStyle(.stone700)
      },
      leftView: {
        Button(action: {dismiss()}, label: {
          Image("angle-left")
            .frame(width: 20, height: 20)
        })
      },
      rightView: {
        Button {
          try? answerVM.createAnswer(questionId: question.questionID)
          dismiss()
        } label: {
          Text("완료")
            .fontWithTracking(.headlineR)
            .foregroundStyle(.stone700)
        }
      })
    .background(backgroundDefault())
  }
}

extension AnswerWriteView {
  
  private var questionText: some View {
    HStack(alignment: .top, spacing: 11) {
      Image("avatar_Female circle GradientBG")
        .resizable()
        .frame(width: 34, height: 34)
      
      VStack {
        LeftPinkChatBubble(text: question.content)
        LeftPinkChatBubble(text: "너의 생각을 알려줘")
      }
      Spacer()
    }
    .padding(.horizontal, 22)
  }
}

#Preview {
  AnswerWriteView(question: .init(questionID: 1, category: "values", content: "반려동물을 기르고싶어?"))
}
