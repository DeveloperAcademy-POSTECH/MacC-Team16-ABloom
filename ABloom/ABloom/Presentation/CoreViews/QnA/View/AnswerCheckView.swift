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
      
      // 남성 일 경우
      if sex {
        malePart
      } else { // 여성 일 경우
        femalePart
      }
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


extension AnswerCheckView {
  
  private var malePart: some View {
    VStack(spacing: 20) {
      Spacer()
        .frame(height: 14)
      // if 상대방과의 연결이 없을 경우
      if answerCheckVM.isNoFiance {
        if !answerCheckVM.isNoMyAnswer {
          RightBlueChatBubble(text: answerCheckVM.myAnswer)
        }
        LeftPinkChatBubbleWithImg(text: "아직 상대방과 연결되어 있지 않아요. 지금 연결하고, 상대방의 문답을 확인해주세요.")
        NavigationLink {
          // 연결하는 뷰로 이동
        } label: {
          LeftPinkChatBubble(text: "연결하기  >", isBold: true)
        }
        
        // if 내가 먼저 답하고, 상대방의 답변을 기다릴 경우
      } else if answerCheckVM.isNoFianceAnswer && !answerCheckVM.isNoMyAnswer {
        RightBlueChatBubble(text: answerCheckVM.myAnswer)
        LeftPinkChatBubbleWithImg(text: "상대방의 답변을 기다리고 있어요.")
      }
      
      // if 상대방이 답하고, 상대방이 내 답변을 기다릴 경우 => 내비게이션 연결
      else if !answerCheckVM.isNoFianceAnswer && answerCheckVM.isNoMyAnswer {
        LeftPinkChatBubbleWithImg(text: "(상대방 이름)님이 답변을 등록했어요. 답변을 확인해보려면 나의 문답을 작성해주세요.")
        NavigationLink {
          if let question = answerCheckVM.question {
            AnswerWriteView(question: question)
          }
        } label: {
          RightBlueChatBubble(text: "문답 작성하기  >", isBold: true)
        }
      }
      
      // 둘 다 작성했을 경우 => 내 답변이 먼저 보이기
      else {
        RightBlueChatBubble(text: answerCheckVM.myAnswer)
        LeftPinkChatBubbleWithImg(text: answerCheckVM.fianceAnswer)
      }
      
      Spacer()
    }
    .padding(.horizontal, 20)
    .background(backWall())
  }
  
  private var femalePart: some View {
    // 답변 확인 뷰
    VStack(spacing: 20) {
      Spacer()
        .frame(height: 14)
      
      // if 상대방과의 연결이 없을 경우
      if answerCheckVM.isNoFiance {
        if !answerCheckVM.isNoMyAnswer {
          RightPinkChatBubble(text: answerCheckVM.myAnswer)
        }
        LeftBlueChatBubbleWithImg(text: "아직 상대방과 연결되어 있지 않아요. 지금 연결하고, 상대방의 문답을 확인해주세요.")
        NavigationLink {
          // TODO: 연결하는 뷰로 이동
        } label: {
          LeftBlueChatBubble(text: "연결하기  >", isBold: true)
        }
        
        // if 내가 먼저 답하고, 상대방의 답변을 기다릴 경우
      } else if answerCheckVM.isNoFianceAnswer && !answerCheckVM.isNoMyAnswer {
        RightPinkChatBubble(text: answerCheckVM.myAnswer)
        LeftBlueChatBubbleWithImg(text: "상대방의 답변을 기다리고 있어요.")
      }
      
      // if 상대방이 답하고, 상대방이 내 답변을 기다릴 경우 => 내비게이션 연결
      else if !answerCheckVM.isNoFianceAnswer && answerCheckVM.isNoMyAnswer {
        LeftBlueChatBubbleWithImg(text: "(상대방 이름)님이 답변을 등록했어요. 답변을 확인해보려면 나의 문답을 작성해주세요.")
        NavigationLink {
          if let question = answerCheckVM.question {
            AnswerWriteView(question: question)
          }
        } label: {
          RightPinkChatBubble(text: "문답 작성하기  >", isBold: true)
        }
      }
      
      // 둘 다 작성했을 경우 => 내 답변이 먼저 보이기
      else {
        RightBlueChatBubble(text: answerCheckVM.myAnswer)
        LeftPinkChatBubbleWithImg(text: answerCheckVM.fianceAnswer)
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
