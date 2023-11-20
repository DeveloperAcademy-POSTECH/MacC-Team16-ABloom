//
//  CheckAnswerView.swift
//  ABloom
//
//  Created by 정승균 on 11/15/23.
//

import SwiftUI

struct CheckAnswerView: View {
  @StateObject var checkAnswerVM = CheckAnswerViewModel()
  
  let question: DBStaticQuestion
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 40) {
        questionArea
        
        myAnswerArea
        
        fianceAnswerArea
        
        reactionArea
      }
      .padding(.top, 46)
      .frame(maxWidth: .infinity)
      .multilineTextAlignment(.leading)
    }
    .padding(.horizontal, 20)
    .customNavigationBar {
      Text("우리의 문답")
        .customFont(.bodyB)
    } leftView: {
      Button {
        dismiss()
      } label: {
        Image("xmark")
          .renderingMode(.template)
          .foregroundStyle(.purple700)
      }
    } rightView: {
      EmptyView()
    }
    .background(Color.background)
    .overlay {
      if checkAnswerVM.showSelectReactionView {
        Color.black.opacity(0.4).ignoresSafeArea()
        SelectReactionView(checkAnswerVM: checkAnswerVM)
      }
    }
  }
}

extension CheckAnswerView {
  private var questionArea: some View {
    HStack {
      VStack(alignment: .leading, spacing: 6) {
        Text(question.content.useNonBreakingSpace())
          .customFont(.headlineB)
        Text("\(checkAnswerVM.date.formatToYMD())")
          .customFont(.caption2R)
          .foregroundStyle(.gray500)
      }
      
      Spacer()
    }
  }
  
  private var myAnswerArea: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("\(checkAnswerVM.currentUserName)님의 대답")
        .customFont(.calloutB)
      Text(checkAnswerVM.currentUserAnswerContent.useNonBreakingSpace())
        .customFont(.footnoteR)
        .foregroundStyle(.gray500)
    }
  }
  
  private var fianceAnswerArea: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("\(checkAnswerVM.fianceName)님의 대답")
        .customFont(.calloutB)
      Text(checkAnswerVM.fianceAnswerContent.useNonBreakingSpace())
        .customFont(.footnoteR)
        .foregroundStyle(.gray500)
    }
  }
  
  private var reactionArea: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("우리의 반응")
        .customFont(.calloutB)
      Text("둘 다 답변을 작성하면 우리만의 반응을 추가할 수 있어요.")
        .customFont(.footnoteR)
        .foregroundStyle(.gray500)
        .padding(.bottom, 30)
      
      HStack(alignment: .bottom) {
        Circle()
          .frame(width: 84, height: 84)
        Spacer()
        Circle()
          .frame(width: 124, height: 124)
        Spacer()
        Button {
          checkAnswerVM.tapSelectReactionButton()
        } label: {
          Circle()
            .frame(width: 84, height: 84)
        }
      }
      .foregroundStyle(.gray300)
    }
  }
}

#Preview {
  CheckAnswerView(question: DBStaticQuestion(questionID: 1, category: "경제", content: "question"))
}
