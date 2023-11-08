//
//  QuestionWriteView.swift
//  ABloom
//
//  Created by yun on 10/25/23.
//

import SwiftUI

struct AnswerWriteView: View {
  var question: DBStaticQuestion
  let isFromMain: Bool
  
  @StateObject var answerVM = AnswerWriteViewModel()
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    VStack(spacing: 20) {
      
      Spacer().frame(height: 0)
      
      if answerVM.isReady {
        
        CategoryQuestionBox(question: question.content)
          .padding(.horizontal, 20)

        answerText
        
      } else {
        
        ProgressView()
        
      }
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
    
    .onAppear(perform: UIApplication.shared.hideKeyboard)
    
    .task {
      try? await answerVM.getUserSex()
    }
    
    // 네비게이션바
    .customNavigationBar(
      centerView: {
        Text("답변 작성하기")
      },
      leftView: {
        Button {
          if answerVM.answerText == "" {
            dismiss()
          } else {
            answerVM.setAlert()
          }
        } label: {
          Image("angle-left")
            .frame(width: 20, height: 20)
        }
      },
      rightView: {
        Button {
          if !isFromMain {
            NavigationModel.shared.popToMainToggle()
          }
          try? answerVM.createAnswer(questionId: question.questionID)
          dismiss()
        } label: {
          Text("완료")
            .fontWithTracking(.headlineR)
            .foregroundStyle(.stone700)
        }
        .disabled(answerVM.answerText == "")
      })
    .background(backgroundDefault())
  }
}

extension AnswerWriteView {
  
  private var answerText: some View {
    HStack {
      Spacer()
      
      ChatBubbleTextField(text: $answerVM.answerText)
        .onChange(of: answerVM.answerText, perform: { newValue in
          if newValue.count > 150 {
            answerVM.answerText = String(newValue.prefix(150))
          }
          // 내용이 있을 때, 스와이프 방지
          if !newValue.isEmpty {
            UINavigationController.isSwipeBackEnabled = false
          } else {
            UINavigationController.isSwipeBackEnabled = true
          }
        })
        .padding(.horizontal, 22)
    }
  }
}

#Preview {
  AnswerWriteView(question: .init(questionID: 1, category: "values", content: "반려동물을 기르고싶어?"), isFromMain: false)
}
