//
//  SelectReactionView.swift
//  ABloom
//
//  Created by Lee Jinhee on 11/20/23.
//

import SwiftUI

struct SelectReactionView: View {
  @Environment(\.dismiss) private var dismiss
  @ObservedObject var checkAnswerVM: CheckAnswerViewModel
  
  var body: some View {
    VStack(spacing: 10) {
      Text("반응 선택하기")
        .customFont(.title3B)
      Text("서로의 답변을 확인했나요?\n우리의 문답에 나의 반응을 추가해보세요.")
        .customFont(.subHeadlineR)
        .padding(.bottom, 27)
        .multilineTextAlignment(.center)
      
      reactionArea
      
      Button {
        checkAnswerVM.showSelectReactionView = false
      } label: {
        PurpleTextButton(title: "완료")
      }
    }
    .padding(.top, 42)
    .padding(.bottom, 62)
    .padding(.horizontal, 16)
    .background(Color.white)
    .cornerRadius(16, corners: .allCorners)
    .padding(.horizontal, 20)
  }
}

extension SelectReactionView {
  private var reactionArea: some View {
    VStack(spacing: 29) {
      HStack {
        reactionButton(reaction: .good)
        reactionButton(reaction: .knowEachOther)
      }
      .frame(height: 128)
      
      HStack {
        reactionButton(reaction: .moreCommunication)
        reactionButton(reaction: .moreResearch)
      }
      .frame(height: 128)
    }
  }
  
  private func reactionButton(reaction: ReactionType) -> some View {
    Button {
      checkAnswerVM.selectedReaction = reaction
    } label: {
      Text(reaction.reactionContent)
        .background(checkAnswerVM.selectedReaction == reaction ? .purple300 : .purple100)
    }
  }
}

#Preview {
  SelectReactionView(checkAnswerVM: CheckAnswerViewModel())
    .background(Color.black)
}
