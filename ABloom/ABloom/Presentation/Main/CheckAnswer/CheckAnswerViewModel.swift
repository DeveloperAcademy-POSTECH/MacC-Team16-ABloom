//
//  CheckAnswerViewModel.swift
//  ABloom
//
//  Created by Lee Jinhee on 11/20/23.
//

import Foundation

enum FianceAnswerStatus {
  case unconnected /// 연결안된 상태
  case noAnswered /// no 내가 먼저 답한 문답 기다리는 상태
  case answered /// 상대방은 대답한 상태
}

enum CurrentUserAnswerStatus {
  case noAnswered /// 대답안한 상태
  case answered /// 대답한 상태
}

final class CheckAnswerViewModel: ObservableObject {
  
  @Published var currentUserAnswer: DBAnswer = DBAnswer(questionId: 1, userId: "dd", answerContent: "현재유저의 대답이다", isComplete: false, reaction: nil)
  @Published var fianceAnswer: DBAnswer = DBAnswer(questionId: 1, userId: "dd", answerContent: "좋아요", isComplete: false, reaction: nil)
  @Published var currentUserName: String = "사용자"
  @Published var fianceName: String = "상대방"
  @Published var date: Date = .now
    
  @Published var showSelectReactionView: Bool = false
  @Published var selectedReaction: ReactionType = .error

  private var currentUserAnswerStatus: CurrentUserAnswerStatus = .answered
  private var fianceAnswerStatus: FianceAnswerStatus = .answered
  
  var currentUserAnswerContent: String {
    switch currentUserAnswerStatus {
    case .noAnswered:
      "\(fianceName)님의 답변을 확인해보려면 나의 답변도 작성해주세요."
    case .answered:
      currentUserAnswer.answerContent
    }
  }
  
  var fianceAnswerContent: String {
    switch fianceAnswerStatus {
    case .unconnected:
      "상대방과 연결되어 있지 않아요. 연결되면 우리만의 문답을 함께 작성해갈 수 있어요."
    case .noAnswered:
      "상대방의 답변을 기다리고 있어요. 답변이 작성되면 푸쉬 알림으로 알려드릴게요."
    case .answered:
      if currentUserAnswerStatus == .answered {
        fianceAnswer.answerContent
      } else {
        "잠겨있어요!"
      }
    }
  }
  
  func checkAnswerStatus() {
    
  }
  
  func tapSelectReactionButton() {
    showSelectReactionView = true
  }
  
  func updateReaction() {
    // TODO: UpdateReaction
    showSelectReactionView = false
    
  }
}
