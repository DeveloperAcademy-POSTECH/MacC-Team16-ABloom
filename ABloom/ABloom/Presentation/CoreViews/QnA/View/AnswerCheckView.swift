//
//  AnswerView.swift
//  ABloom
//
//  Created by yun on 10/22/23.
//

import SwiftUI

struct AnswerCheckView: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject var answerCheckVM: AnswerCheckViewModel
  
  var body: some View {
    VStack {
      if let question = answerCheckVM.question {
        CategoryQuestionBox(
          question: question.content,
          category: "\((Category(rawValue: question.category)?.type)!) 질문",
          categoryImg: (Category(rawValue: question.category)?.imgName)!
        )
        .padding(.vertical, 30)
      }
      
      Spacer()
        .frame(height: 10)
      
      // TODO: 데이터의 타임 스탬프를 비교하여, 먼저 작성한 답변이 위로 보여야 함
      VStack(spacing: 20) {
        Spacer()
          .frame(height: 14)
        
        RightPinkChatBubble(text: answerCheckVM.myAnswer)
        
        
        HStack(alignment: .top, spacing: 13) {
          Image("avatar_Male circle GradientBG")
            .resizable()
            .frame(width: 34, height: 34)
          
          // TODO: 성별에 따른 색상 구분
          LeftBlueChatBubble(text: answerCheckVM.fianceAnswer.isEmpty ? "상대방의 답변을 기다리고 있어요." : answerCheckVM.fianceAnswer)
          
          // TODO: 답변 상태에 따른 메세지 로직 구현 필요 @Lia
          if answerCheckVM.isNoFiance {
            LeftBlueChatBubble(text: "상대 없음")
          }
          
          if answerCheckVM.isNoFianceAnswer {
            LeftBlueChatBubble(text: "상대 답변 없음 ")
          }
          
          if answerCheckVM.isNoMyAnswer {
            LeftBlueChatBubble(text: "내 답변 없음")
          }
        }
        
        Spacer()
      }
      .padding(.horizontal, 20)
      .background(backWall())
    }
    .onAppear {
      answerCheckVM.getAnswers()
    }
    
    .customNavigationBar(
      centerView: {
        Text("우리의 문답")
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
        EmptyView()
      })
    
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(backgroundDefault())
  }
}

#Preview {
  AnswerCheckView(answerCheckVM: .init(questionId: 1))
}
