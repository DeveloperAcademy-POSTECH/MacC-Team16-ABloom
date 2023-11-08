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
        CategoryQuestionBox(question: question.content)
        .padding(.vertical, 30)
        .padding(.horizontal, 20)
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
          RightPurpleChatBubble(text: answerCheckVM.myAnswer?.answerContent ?? "")
        }
        LeftChatBubbleWithImg(text: answerCheckVM.notConnectedText, isMale: !self.sex)
        NavigationLink {
          MyAccountConnectingView()
        } label: {
          ChatBubbleBtn(text: "연결하기  >")
        }
        .padding(.leading, 40)
        
        // if 내가 먼저 답하고, 상대방의 답변을 기다릴 경우
      } else if answerCheckVM.isNoFianceAnswer && !answerCheckVM.isNoMyAnswer {
        RightPurpleChatBubble(text: answerCheckVM.myAnswer?.answerContent ?? "")
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
          ChatBubbleBtn(text: "문답 작성하기  >")
        }
      }
      
      // 둘 다 작성했을 경우 => 내 답변이 먼저 보이기
      else {
        RightPurpleChatBubble(text: answerCheckVM.myAnswer?.answerContent ?? "")
        LeftChatBubbleWithImg(text: answerCheckVM.fianceAnswer?.answerContent ?? "", isMale: !self.sex)
        
        // 리액션 버튼 구현
        Button(action: {
          try? answerCheckVM.reactToAnswer(reaction: .good)
        }, label: {
          Text("좋아용")
        })
        
        Button(action: {
          try? answerCheckVM.reactToAnswer(reaction: .knowEachOther)
        }, label: {
          Text("서로에 대해 더 알게")
        })
        
        Button(action: {
          try? answerCheckVM.reactToAnswer(reaction: .moreCommunication)
        }, label: {
          Text("더 대화 해보실")
        })
        
        Button(action: {
          try? answerCheckVM.reactToAnswer(reaction: .moreResearch)
        }, label: {
          Text("더 찾아볼듯")
        })
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
