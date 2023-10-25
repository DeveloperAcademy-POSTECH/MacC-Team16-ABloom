//
//  AnswerView.swift
//  ABloom
//
//  Created by yun on 10/22/23.
//

import SwiftUI

struct AnswerCheckView: View {
  @Environment(\.dismiss) private var dismiss
  
  // 차후에 데이터를 받아올 변수 => 현재는 임의로 지정
  let num: Int
  
  var body: some View {
    VStack {
      // MARK: Header
      CategoryQuestionBox(
        question: "반려동물을 기르고 싶어?",
        category: "경제 질문",
        categoryImg: "squareIcon_isometric_health"
      )
      
      Spacer()
        .frame(height: 40)
      
      // MARK: Content
      
      // TODO: 데이터의 타임 스탬프를 비교하여, 먼저 작성한 답변이 위로 보여야 함
      VStack(spacing: 20) {
        Spacer()
          .frame(height: 14)
        
        RightPinkChatBubble(text: "나는 고양이가 좋아! 아픈 길고양이들을 보면 데려와서 키우고 싶다는 생각도 종종 들어 ㅎㅎ\n우리도 함께 키우다보면 예쁜 추억들이 더 많이 생길 거 같아!!")
        
        
        HStack(alignment: .top, spacing: 13) {
          Image("avatar_Male circle GradientBG")
            .resizable()
            .frame(width: 34, height: 34)
          
          // TODO: 답변 유무와 성별에 따라서 다른 컴포넌트 활용,,
          LeftBlueChatBubble(text: "상대방의 답변을 기다리고 있어요.")
        }
      
        Spacer()
      }
      .padding(.horizontal, 20)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(backWall())
    }
    
    // MARK: NavigationBar
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
  AnswerCheckView(num: 1)
}
