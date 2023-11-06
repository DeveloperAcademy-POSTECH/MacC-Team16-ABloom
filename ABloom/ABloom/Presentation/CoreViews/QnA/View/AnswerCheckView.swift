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
  
  let sex: Bool
  
  var body: some View {
    VStack {
      
      // 질문 박스
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
      
      if answerCheckVM.isDataReady == false {
        VStack {
          ProgressView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backWall())
      } else {
        answerText
      }
    }
    
    .customNavigationBar(
      centerView: {
        Text("우리의 문답")
      },
      leftView: {
        Button {
          dismiss()
        } label: {
          NavigationArrowLeft()
        }
      },
      rightView: {
        EmptyView()
      })
    
    .onAppear {
      answerCheckVM.getAnswers()
      
      print(answerCheckVM.isDataReady)
      
      if NavigationModel.shared.isPopToMain {
        NavigationModel.shared.popToMainToggle()
        dismiss()
      }
    }
    
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(backgroundDefault())
  }
}


extension AnswerCheckView {
  
  private var answerText: some View {
    VStack(spacing: 20) {
      Spacer()
        .frame(height: 14)
      // if 상대방과의 연결이 없을 경우
      if answerCheckVM.isNoFiance {
        if !answerCheckVM.isNoMyAnswer {
          RightChatBubble(text: answerCheckVM.myAnswer, isMale: self.sex)
        }
        LeftChatBubbleWithImg(text: answerCheckVM.notConnectedText, isMale: !self.sex)
        NavigationLink {
          MyAccountConnectingView()
        } label: {
          LeftChatBubble(text: "연결하기  >", isBold: true, isMale: self.sex)
        }
        .padding(.leading, 40)
        
        // if 내가 먼저 답하고, 상대방의 답변을 기다릴 경우
      } else if answerCheckVM.isNoFianceAnswer && !answerCheckVM.isNoMyAnswer {
        RightChatBubble(text: answerCheckVM.myAnswer, isMale: self.sex)
        LeftChatBubbleWithImg(text: answerCheckVM.waitText, isMale: !self.sex)
      }
      
      // if 상대방이 답하고, 상대방이 내 답변을 기다릴 경우 => 내비게이션 연결
      else if !answerCheckVM.isNoFianceAnswer && answerCheckVM.isNoMyAnswer {
        LeftChatBubbleWithImg(text: "\(answerCheckVM.fianceName)님이 답변을 등록했어요. 답변을 확인해보려면 나의 문답을 작성해주세요.", isMale: !self.sex)
        NavigationLink {
          if let question = answerCheckVM.question {
            AnswerWriteView(question: question, isFromMain: false)
          }
        } label: {
          RightChatBubble(text: "문답 작성하기  >", isBold: true, isMale: self.sex)
        }
      }
      
      // 둘 다 작성했을 경우 => 내 답변이 먼저 보이기
      else {
        RightChatBubble(text: answerCheckVM.myAnswer, isMale: self.sex)
        LeftChatBubbleWithImg(text: answerCheckVM.fianceAnswer, isMale: !self.sex)
      }
      
      Spacer()
    }
    .padding(.horizontal, 20)
    .background(backWall())
  }
  
}

#Preview {
  AnswerCheckView(answerCheckVM: .init(questionId: 3), sex: true)
}
