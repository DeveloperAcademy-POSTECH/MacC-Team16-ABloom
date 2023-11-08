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
        
        reactSection
      }
      
      Spacer()
    }
    .padding(.horizontal, 20)
    .background(backWall())
  }
  
  private var reactSection: some View {
    VStack {
      if answerCheckVM.hasMyReaction && answerCheckVM.hasFianceReaction {
        // 내 반응 상대 반응 다 보여주기
        Text("내 반응 : \(answerCheckVM.myAnswer?.reactionType.reactionContent ?? "")")
        Text("상대 반응 : \(answerCheckVM.fianceAnswer?.reactionType.reactionContent ?? "")")
        
        completeSection
        
      } else if answerCheckVM.hasMyReaction {
        // 내 반응만 보여주기
        Text("내 반응 : \(answerCheckVM.myAnswer?.reactionType.reactionContent ?? "")")
        
      } else if answerCheckVM.hasFianceReaction {
        // 상대 반응과 버튼 보여주기
        Text("상대 반응 : \(answerCheckVM.fianceAnswer?.reactionType.reactionContent ?? "")")
        
        reactionButtons
        
      } else {
        // 버튼만 보여주기
        reactionButtons
        
      }
    }
  }
  
  private var reactionButtons: some View {
    VStack {
      // 리액션 버튼 구현
      reactionButton(reaction: .good)
      
      reactionButton(reaction: .knowEachOther)
      
      reactionButton(reaction: .moreCommunication)
      
      reactionButton(reaction: .moreResearch)
    }
  }
  
  private func reactionButton(reaction: ReactionType) -> some View {
    Button {
      try? answerCheckVM.reactToAnswer(reaction: reaction)
    } label: {
      Text(reaction.reactionContent)
    }
  }
  
  private var completeSection: some View {
    VStack {
      if answerCheckVM.bothPositiveReaction {
        // 바로 완성되었어요
        Text("문답이 완성됐어요 보여주기")
        
      } else if answerCheckVM.isCompleteMyAnswer && answerCheckVM.isCompleteFianceAnswer {
        // 서로 응답 완
        Text("문답이 완성됐어요 + 서로 완성상태 변경 보여주기")
        
      } else if answerCheckVM.isCompleteMyAnswer {
        // 나만 응답 완
        Text("대기중")
        
      } else if answerCheckVM.isCompleteFianceAnswer {
        // 상대만 응답 완, 버튼 보여주기
        Text("상대가 대기중")
        
        Button {
          try? answerCheckVM.completeAnswer()
        } label: {
          Text("✅ 문답 완성하기")
        }
        
      } else {
        // 버튼만 보여주기
        Button {
          try? answerCheckVM.completeAnswer()
        } label: {
          Text("✅ 문답 완성하기")
        }
        
      }
    }
  }
}

#Preview {
  AnswerCheckView(answerCheckVM: .init(questionId: 3), sex: true)
}
