//
//  SelectReactionView.swift
//  ABloom
//
//  Created by Lee Jinhee on 11/20/23.
//

import SwiftUI

struct SelectReactionView: View {
  @ObservedObject var checkAnswerVM: CheckAnswerViewModel
  
  var body: some View {
    VStack(spacing: 10) {
      Text("반응 선택하기")
        .customFont(.title3B)
        .padding(.bottom, 10)
      
      Text("서로의 답변을 확인했나요?\n우리의 문답에 나의 반응을 추가해보세요.")
        .customFont(.subHeadlineR)
        .padding(.bottom, 27)
        .multilineTextAlignment(.center)
      
      reactionArea
        .padding(.bottom, 20)

      Button {
        checkAnswerVM.showSelectReactionView = false
        checkAnswerVM.updateReaction()
      } label: {
        PurpleTextButton(title: "완료")
      }
    }
    .padding(.top, 42)
    .padding(.bottom, 26)
    .padding(.horizontal, 16)
    .background(Color.white)
    .cornerRadius(16, corners: .allCorners)
    .overlay(alignment: .topLeading) {
      Button {
        checkAnswerVM.showSelectReactionView = false
      } label: {
        Image("xmark")
          .resizable()
          .renderingMode(.template)
          .frame(width: 16, height: 16)
          .foregroundStyle(.gray400)
          .padding(.all, 16)
      }
    }
    .padding(.horizontal, 20)
  }
}

extension SelectReactionView {
  private var reactionArea: some View {
    VStack(spacing: 20) {
      HStack(spacing: 30) {
        reactionButton(reaction: .good)
        reactionButton(reaction: .knowEachOther)
      }
      
      HStack(spacing: 30) {
        reactionButton(reaction: .moreCommunication)
        reactionButton(reaction: .moreResearch)
      }
    }
  }
  
  private func reactionButton(reaction: ReactionType) -> some View {
    Button {
      checkAnswerVM.selectedReaction = ReactionStatus.react(reaction)
    } label: {
      VStack {
        Image(reaction.imageName)
          .resizable()
          .frame(width: 124, height: 124)
          
        Text(reaction.reactionContent)
          .font(.reaction14)
          .foregroundStyle(.gray600)
      }
      .opacity(checkAnswerVM.selectedReaction == ReactionStatus.react(reaction) ? 1.0 : 0.4)
    }
  }
}

#Preview {
  SelectReactionView(checkAnswerVM: CheckAnswerViewModel())
    .background(Color.black)
}
