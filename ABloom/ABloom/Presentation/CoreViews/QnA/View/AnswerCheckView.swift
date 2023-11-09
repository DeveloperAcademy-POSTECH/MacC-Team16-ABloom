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
          .padding(.vertical, 20)
          .padding(.horizontal, 20)
      }
      
      if answerCheckVM.isDataReady == false {
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else {
        answerText
        
        Spacer()
      }
    }
    .background(backgroundDefault())
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
        reactionSubmitButton
          .foregroundStyle(.stone700)
      })
    
    .overlay(content: {
      if answerCheckVM.showTip {
        TipView(isPresent: $answerCheckVM.showTip)
          .zIndex(1)
      }
    })
    
    .onAppear {
      answerCheckVM.getAnswers()
      
      print(answerCheckVM.isDataReady)
      
      if NavigationModel.shared.isPopToMain {
        NavigationModel.shared.popToMainToggle()
        dismiss()
      }
    }
  }
}


extension AnswerCheckView {
  
  private var answerText: some View {
    VStack(spacing: 12) {
      ChatCallout(text: "서로의 답변")
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
      
    }
    .padding(.horizontal, 20)
  }
  
  private var reactSection: some View {
    VStack(spacing: 12) {
      ChatCallout(text: "반응 남기기")
      
      if answerCheckVM.hasMyReaction && answerCheckVM.hasFianceReaction {
        // 내 반응 상대 반응 다 보여주기
        RightPurpleChatBubble(text: "\(answerCheckVM.myName)님이 새로운 반응을 남겼어요.\n \"\(answerCheckVM.myAnswer?.reactionType.reactionContent ?? "")\"")
        LeftChatBubbleWithImg(text: "\(answerCheckVM.fianceName)님이 새로운 반응을 남겼어요.\n\"\(answerCheckVM.fianceAnswer?.reactionType.reactionContent ?? "")\"", isMale: !self.sex)
        
        completeSection
        
      } else if answerCheckVM.hasMyReaction {
        // 내 반응만 보여주기
        RightPurpleChatBubble(text: "\(answerCheckVM.myName)님이 새로운 반응을 남겼어요.\n \"\(answerCheckVM.myAnswer?.reactionType.reactionContent ?? "")\"")
        LeftChatBubbleWithImg(text: "\(answerCheckVM.fianceName)님의 반응을 기다리고 있어요.", isMale: !self.sex)
      } else if answerCheckVM.hasFianceReaction {
        // 상대 반응과 버튼 보여주기
        LeftChatBubbleWithImg(text: "\(answerCheckVM.fianceName)님이 새로운 반응을 남겼어요. 나도 반응을 선택하면 서로 확인할 수 있어요.", isMale: !self.sex)
        
        reactionButtons
        
      } else {
        // 버튼만 보여주기
        reactionButtons
      }
    }
    .padding(.top, 8)
  }
  
  private var reactionButtons: some View {
    VStack(spacing: 12) {
      // 리액션 버튼 구현
      reactionButton(reaction: .good)
      
      reactionButton(reaction: .knowEachOther)
      
      reactionButton(reaction: .moreCommunication)
      
      reactionButton(reaction: .moreResearch)
    }
  }
  
  private func reactionButton(reaction: ReactionType) -> some View {
    Button {
      self.answerCheckVM.reactButtonTapped = true
      self.answerCheckVM.myReaction = reaction
    } label: {
      ChatBubbleBtn(
        text: reaction.reactionContent,
        disabled: answerCheckVM.myReaction != reaction
      )
    }
  }
  
  private var reactionSubmitButton: some View {
    answerCheckVM.reactButtonTapped ?
    Button {
      try? answerCheckVM.reactToAnswer()
    } label: {
      Text("선택")
        .font(.headlineR)
    }
    : Button { } label: { Text("") }
  }
  
  // MARK: Complete Area
  private var completeSection: some View {
    VStack(spacing: 12) {
      if answerCheckVM.bothPositiveReaction {
        // 바로 완성되었어요
        ChatCallout(text: "문답이 완성되었어요")
      } else {
        Button {
          answerCheckVM.showTip.toggle()
        } label: {
          ChatCallout(text: "더 대화해보기")
        }
        
        if answerCheckVM.isCompleteMyAnswer && answerCheckVM.isCompleteFianceAnswer {
          // 서로 응답 완 + 서로 완성상태 변경
          LeftChatBubbleWithImg(text: "\(answerCheckVM.fianceName)님이 응답의 상태를 '완성'으로 변경했어요.", isMale: !self.sex)
          RightPurpleChatBubble(text: "\(answerCheckVM.myName)님이 응답의 상태를 '완성'으로 변경했어요.")
          ChatCallout(text: "문답이 완성되었어요")
          
        } else if answerCheckVM.isCompleteMyAnswer {
          // 나만 응답 완
          RightPurpleChatBubble(text: "\(answerCheckVM.myName)님이 응답의 상태를 '완성'으로 변경했어요.")
          LeftChatBubbleWithImg(text: "\(answerCheckVM.fianceName)님의 확인을 기다리고 있어요.", isMale: !self.sex)
          
        } else if answerCheckVM.isCompleteFianceAnswer {
          // 상대만 응답 완, 버튼 보여주기
          LeftChatBubbleWithImg(text: "\(answerCheckVM.fianceName)님의 확인을 기다리고 있어요.", isMale: !self.sex)
          
          Button {
            try? answerCheckVM.completeAnswer()
          } label: {
            ChatBubbleBtn(text: "✅ 문답 완성하기")
          }
          
        } else {
          // 버튼만 보여주기
          Button {
            try? answerCheckVM.completeAnswer()
          } label: {
            ChatBubbleBtn(text: "✅ 문답 완성하기")
          }
        }
      }
    }
    .padding(.top, 8)
  }
}

#Preview {
  AnswerCheckView(answerCheckVM: .init(questionId: 3), sex: true)
}
