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
      
      answerText
      
    }
    
    // alert
    .alert("삭제하시겠어요?", isPresented: $answerVM.isAlertOn, actions: {
      Button(action: {dismiss()}, label: {
        Text("삭제")
          .foregroundStyle(.purple600)
      })
      Button(role: .cancel, action: {}, label: {
        Text("취소")
          .foregroundStyle(.purple600)
      })
    }, message: {
      Text("지금 뒤로 나가면 작성했던 답변이\n삭제되고, 복구할 수 없어요.")
    })
    
    // 네비게이션바
    .customNavigationBar(
      centerView: {
        Text("문답 작성하기")
          .fontWithTracking(.title3R)
          .foregroundStyle(.stone700)
      },
      leftView: {
        Button(action: answerVM.moveToBack,
               label: {
          Image("angle-left")
            .frame(width: 20, height: 20)
        })
      },
      rightView: {
        NavigationLink {
          // popToRoot 구현 => NavigationStack path 설정 필요
          // QuestionMainView()
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
      
      // 유저가 남성일 때,
      //      Image("avatar_Female circle GradientBG")
      //        .resizable()
      //        .frame(width: 34, height: 34)
      //
      //      VStack {
      //        LeftPinkChatBubble(text: question.content)
      //        LeftPinkChatBubble(text: "너의 생각을 알려줘")
      //      }
      
      
      // 유저가 여성일 떄,
      Image("avatar_Male circle GradientBG")
        .resizable()
        .frame(width: 34, height: 34)
      
      VStack {
        LeftBlueChatBubble(text: question.content)
        LeftBlueChatBubble(text: "너의 생각을 알려줘")
      }
      
      Spacer()
    }
    .padding(.horizontal, 22)
  }
  
  private var answerText: some View {
    HStack {
      Spacer()
      
      // 유저가 남성일 때,
      // BlueChatBubbleTextField(text: $answerVM.answerText)
      
      // 유저가 여성일 떄,
      PinkChatBubbleTextField(text: $answerVM.answerText)
      
        .onChange(of: answerVM.answerText, perform: { newValue in
        if newValue.count > 150 {
            answerVM.answerText = String(newValue.prefix(150))
        }
        })
        .padding(.horizontal, 22)
    }
  }
}
