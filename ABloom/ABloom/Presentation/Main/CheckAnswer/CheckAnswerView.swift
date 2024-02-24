//
//  CheckAnswerView.swift
//  ABloom
//
//  Created by 정승균 on 11/15/23.
//

import SwiftUI

struct CheckAnswerView: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject var checkAnswerVM = CheckAnswerViewModel()

  let question: DBStaticQuestion
  
  var body: some View {
    ScrollView {
      if checkAnswerVM.isDataReady {
        VStack(alignment: .leading, spacing: 40) {
          questionArea
          
          myAnswerArea
          
          fianceAnswerArea
          
          reactionArea
        }
        .padding(.top, 46)
        .padding(.bottom, 30)
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.leading)
      } else {
        ProgressView()
          .frame(maxHeight: .infinity)
      }
    }
    .scrollIndicators(.hidden)
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
    .background(.white)
    .overlay {
      if checkAnswerVM.showSelectReactionView {
        Color.black.opacity(0.4).ignoresSafeArea()
        SelectReactionView(checkAnswerVM: checkAnswerVM)
      }
    }
    .task {
      checkAnswerVM.getAnswers(dbQuestion: question)
    }
  }
}

extension CheckAnswerView {
  private var questionArea: some View {
    HStack {
      VStack(alignment: .leading, spacing: 12) {
        Text(question.content.containsNumbers() ? question.content : question.content.useNonBreakingSpace())
          .customFont(.headlineB)
        Text(checkAnswerVM.recentDate.formatToYMD())
          .customFont(.caption2R)
          .foregroundStyle(.gray500)
      }
      
      Spacer()
    }
  }
  
  private var myAnswerArea: some View {
    HStack {
      VStack(alignment: .leading, spacing: 12) {
        Text("\(checkAnswerVM.currentUserName)님의 대답")
          .customFont(.calloutB)
        Text(checkAnswerVM.currentUserAnswerContent.useNonBreakingSpace())
          .customFont(.footnoteR)
          .foregroundStyle(.gray500)
        
        HStack {
          Spacer()
          if checkAnswerVM.currentUserAnswer == nil {
            buttonView(type: .write)
          }
        }
        .padding(.top, -6)
      }
      Spacer(minLength: 0)
    }
  }
  
  private var fianceAnswerArea: some View {
    HStack {
      VStack(alignment: .leading, spacing: 12) {
        Text("\(checkAnswerVM.fianceName)님의 대답")
          .customFont(.calloutB)
        Text(checkAnswerVM.fianceAnswerContent.useNonBreakingSpace())
          .customFont(.footnoteR)
          .foregroundStyle(.gray500)
        
        HStack {
          Spacer()
          if checkAnswerVM.fianceUser == nil {
            buttonView(type: .connect)
          }
        }
        .padding(.top, -6)
      }
      Spacer(minLength: 0)
    }
    
  }
  
  private var reactionArea: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("우리의 반응")
        .customFont(.calloutB)
      Text("둘 다 답변을 작성하면 우리만의 반응을 추가할 수 있어요.")
        .customFont(.footnoteR)
        .foregroundStyle(.gray500)
        .padding(.bottom, 30)
      
      HStack(alignment: .bottom) {
        reactionLabelView(reactionStatus: checkAnswerVM.fianceReactionStatus, size: 84)
        
        Spacer(minLength: 4)
        
        reactionLabelView(reactionStatus: checkAnswerVM.coupleReactionStatus, size: 124)
        
        Spacer(minLength: 4)
        
        Button {
          checkAnswerVM.tapSelectReactionButton()
        } label: {
          reactionLabelView(reactionStatus: checkAnswerVM.currentUserReactionStatus, size: 84)
            .overlay(alignment: .bottomTrailing) {
              if checkAnswerVM.currentUserReactionStatus.isReacted {
                Image("ResponseMenu")
                  .resizable()
                  .frame(width: 20, height: 20)
                  .offset(x: -10, y: -30)
              }
            }
        }.disabled(!checkAnswerVM.isAnswersDone)
      }
      .foregroundStyle(.gray300)
    }
  }
  
  private func reactionLabelView<T: Reaction>(reactionStatus: T, size: CGFloat) -> some View {
    let isCoupleReaction = reactionStatus is CoupleReactionStatus
    
    return VStack(spacing: 8) {
      Image(reactionStatus.imageName)
        .resizable()
        .frame(width: size, height: size)
      Text(reactionStatus.reactionContent)
        .font(isCoupleReaction && (reactionStatus as? CoupleReactionStatus != CoupleReactionStatus.lock) ?
          .reaction16 : .reaction14)
        .foregroundStyle(.gray600)
    }
    .frame(width: isCoupleReaction ? 142 : 96)
  }
  
  private func buttonView(type: SheetType) -> some View {
    Button {
      checkAnswerVM.showSheetType = type
      checkAnswerVM.showSheet = true
    } label: {
      Text(type.rawValue)
        .customFont(.footnoteB)
        .foregroundStyle(.gray500)
    }
    .sheet(isPresented: $checkAnswerVM.showSheet) {
      switch checkAnswerVM.showSheetType {
      case .connect: ConnectionView()
      case .write: WriteAnswerView(isSheetOn: $checkAnswerVM.showSheet, question: checkAnswerVM.dbQuestion)
      }
    }
  }
}

#Preview {
  CheckAnswerView(
    question: DBStaticQuestion(questionID: 1, category: "경제", content: "question")
  )
}
