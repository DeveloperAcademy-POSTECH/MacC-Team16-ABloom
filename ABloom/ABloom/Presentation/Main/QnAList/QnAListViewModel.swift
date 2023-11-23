//
//  QnAListViewModel.swift
//  ABloom
//
//  Created by Lee Jinhee on 11/19/23.
//

import SwiftUI

@MainActor
final class QnAListViewModel: ObservableObject {
  static let shared = QnAListViewModel()
  
  @Published var showCheckAnswerView = false
  @Published var checkAnswerQuestion: DBStaticQuestion? = nil
  
  
  @Published var currentUser: DBUser?
  @Published var coupleAnswers: [DBStaticQuestion: [DBAnswer]] = [:]
  
  @Published var viewState: QnAListViewState = .isProgress

  @Published var showProfileSheet: Bool = false
  @Published var showQnASheet: Bool = false
  @Published var showCategoryWayPointSheet: Bool = false
  
  enum QnAListViewState {
    case isProgress
    case isEmpty
    case isSorted
  }
  
  func fetchData() {
    Task {
      getCurrentUser()
      await getQuestions()
      await getAnswers()
    }
  }
  
  func fetchDataAfterSignIn() async {
    try? await UserManager.shared.fetchCurrentUser()
    viewState = .isProgress
    fetchData()
  }
  
  private func getCurrentUser() {
    self.currentUser = UserManager.shared.currentUser
  }
  
  private func getQuestions() async {
    try? await StaticQuestionManager.shared.fetchStaticQuestions()
  }
  
  private func getAnswers() async {
    try? await AnswerManager.shared.fetchMyAnswers()
    try? await AnswerManager.shared.fetchFianceAnswers()

    appendCoupleAnswers()
    
    sortAnswers()
  }
  
  private func appendCoupleAnswers() {
    appendMyAnswers()
    appendFianceAnswers()
    
    if coupleAnswers.isEmpty {
      self.viewState = .isEmpty
    }
  }
  
  private func appendMyAnswers() {
    guard let myAnswers = AnswerManager.shared.myAnswers else { return }
    
    for myAnswer in myAnswers {
      if let dbQuestion = getQuestions(qid: myAnswer.questionId) {
                
        if var answersForQuestion = coupleAnswers[dbQuestion] {
          answersForQuestion.append(myAnswer)
          coupleAnswers[dbQuestion] = answersForQuestion
        } else {
          coupleAnswers[dbQuestion] = [myAnswer]
        }
      }
    }
  }
  
  private func appendFianceAnswers() {
    guard let fianceAnswers = AnswerManager.shared.fianceAnswers else { return }
    for fianceAnswer in fianceAnswers {

      if let dbQuestion = getQuestions(qid: fianceAnswer.questionId) {
        
        if var answersForQuestion = coupleAnswers[dbQuestion] {
          answersForQuestion.append(fianceAnswer)
          coupleAnswers[dbQuestion] = answersForQuestion
        } else {
          coupleAnswers[dbQuestion] = [fianceAnswer]
        }
        
        if self.coupleAnswers[dbQuestion]?.count == 2 {
          self.coupleAnswers[dbQuestion]?.sort(by: { $0.date > $1.date })
        }
      }
    }
  }
  
  private func getQuestions(qid: Int) -> DBStaticQuestion? {
    guard let staticQuestions = StaticQuestionManager.shared.staticQuestions else {
      return nil
    }
    
    return staticQuestions.first { question in
      question.questionID == qid
    }
  }
  
  private func sortAnswers() {
    let answers = self.coupleAnswers.sorted { $0.value[0].date > $1.value[0].date }
    self.coupleAnswers = Dictionary(uniqueKeysWithValues: answers)
    if coupleAnswers.isEmpty {
      viewState = .isEmpty
    } else {
      viewState = .isSorted
    }
  }
  
  func checkAnswerStatus(question: DBStaticQuestion) -> AnswerStatus {
    guard let coupleAnswer = self.coupleAnswers[question] else { return .error }
    guard let myId = UserManager.shared.currentUser?.userId else { return .error }
    
    if coupleAnswer.count == 1 {
      if coupleAnswer[0].userId == myId {
        return .onlyMe
      } else {
        return .onlyFinace
      }
    } else if coupleAnswer.count == 2 {
      
      let coupleReaction0 = coupleAnswer[0].reactionType
      let coupleReaction1 = coupleAnswer[1].reactionType
      
      if coupleReaction0 != .error && coupleReaction1 != .error {
        if coupleReaction0.isPositiveReact() && coupleReaction1.isPositiveReact() {
          return .completed
        } else if [coupleReaction0, coupleReaction1].contains(.moreCommunication) {
          return .moreCommunication
        } else {
          return .moreResearch
        }
      }
      
      if coupleAnswer[0].reaction == nil && coupleAnswer[1].reaction == nil {
        return .reactOnlyFinace
      }
      if coupleAnswer[0].reaction != nil && coupleAnswer[0].userId == myId {
        return .reactOnlyMe
      } else {
        return .reactOnlyFinace
      }
    }
    return .error
  }
  
  func tapProfileButton() {
    showProfileSheet = true
  }
  
  func tapQnAListItem() {
    showQnASheet = true
  }
  
  func tapPlusButton() {
    showCategoryWayPointSheet = true
  }
}
