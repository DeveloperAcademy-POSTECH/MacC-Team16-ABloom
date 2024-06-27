//
//  QnAListViewModel.swift
//  ABloom
//
//  Created by Lee Jinhee on 11/19/23.
//

import Combine
import SwiftUI

enum QnAListViewState {
  case isProgress
  case isEmpty
  case isSorted
}

struct CouplueQnA: Hashable {
  let question: DBStaticQuestion
  var answers: [DBAnswer]
}

@MainActor
final class QnAListViewModel: ObservableObject {
  static let shared = QnAListViewModel()
  
  @Published var currentUser: DBUser?
  
  @Published var currentUserAnswers: [DBAnswer]?
  @Published var fianceAnswers: [DBAnswer]?
  @Published var coupleQnA = [CouplueQnA]()
    
  @Published var viewState: QnAListViewState = .isProgress

  @Published var showProfileSheet: Bool = false
  @Published var showQnASheet: Bool = false
  @Published var showCategoryWayPointSheet: Bool = false
  
  @Published var selectedQuestion: DBStaticQuestion = DBStaticQuestion(questionID: 0, category: "", content: "")
  
  private var cancellables = Set<AnyCancellable>()
  
  func fetchData() {
    Task {
      getCurrentUser()
      await getQuestions()
      await getAnswers()
    }
  }
  
  func fetchDataAfterSignIn() async {
    try? await UserManager.shared.fetchCurrentUser()
    try? await UserManager.shared.fetchFianceUser()
    viewState = .isProgress
    fetchData()
    AnswerManager.shared.addSnapshotListenerForMyAnswer()
  }
  
  private func getCurrentUser() {
    UserManager.shared.$currentUser
      .sink { [weak self] user in
        self?.currentUser = user
      }
      .store(in: &cancellables)
  }
  
  private func getQuestions() async {
    try? await StaticQuestionManager.shared.fetchStaticQuestions()
  }
  
  private func getAnswers() async {
    // TODO: 로그인 시 두 줄 삭제
    try? await AnswerManager.shared.fetchMyAnswers()
    try? await AnswerManager.shared.fetchFianceAnswers()
    
//    self.currentUserAnswers = AnswerManager.shared.myAnswers
//    self.fianceAnswers = AnswerManager.shared.fianceAnswers
    
    await fetchCoupleAnswers()
    
    sortAnswers()
  }
    
  private func fetchCoupleAnswers() async {
   
    AnswerManager.shared.$myAnswers
      .sink { [weak self] answers in
        self?.currentUserAnswers = answers
        self?.updateCoupleAnswers()
      }
      .store(in: &cancellables)
    
    AnswerManager.shared.$fianceAnswers
      .sink { [weak self] answers in
        self?.fianceAnswers = answers
        self?.updateCoupleAnswers()
      }
      .store(in: &cancellables)
  }
  
  private func updateCoupleAnswers() {
    appendCoupleAnswers()
    sortAnswers()
  }
  
  private func appendCoupleAnswers() {
    appendMyAnswers()
    appendFianceAnswers()
    
    if coupleQnA.isEmpty {
      self.viewState = .isEmpty
    }
  }
    
  private func appendMyAnswers() {
    coupleQnA = []
    
    guard let myAnswers = currentUserAnswers else { return }
    
    for myAnswer in myAnswers {
      guard let dbQuestion = getQuestions(qid: myAnswer.questionId) else { return }
      coupleQnA.append(CouplueQnA(question: dbQuestion, answers: [myAnswer]))
    }
  }
  
  private func appendFianceAnswers() {
    guard let fianceAnswers = fianceAnswers else { return }
    
    for fianceAnswer in fianceAnswers {
      guard let dbQuestion = getQuestions(qid: fianceAnswer.questionId) else { return }
      
      let currentUserAnswer = coupleQnA.first { $0.question == dbQuestion }
      
      if currentUserAnswer == nil {
        coupleQnA.append(CouplueQnA(question: dbQuestion, answers: [fianceAnswer]))
      } else {
        guard let idx = coupleQnA.firstIndex(where: { $0.question == dbQuestion }) else { return }
        coupleQnA[idx].answers.append(fianceAnswer)
        coupleQnA[idx].answers.sort { $0.date > $1.date }
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
    self.coupleQnA = self.coupleQnA.sorted { $0.answers[0].date > $1.answers[0].date }
    
    if coupleQnA.isEmpty {
      viewState = .isEmpty
    } else {
      viewState = .isSorted
    }
  }
  
  func checkAnswerStatus(question: DBStaticQuestion) -> AnswerStatus {
    guard let idx = coupleQnA.firstIndex(where: { $0.question == question }) else { return .error }
    
    let coupleAnswer = self.coupleQnA[idx].answers
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
      
      if coupleReaction0 == .error && coupleReaction1 == .error {
        return .reactOnlyFinace
      }
      
      if coupleAnswer[0].userId == myId && coupleReaction0 != .error {
        return .reactOnlyMe
      } else if coupleAnswer[1].userId == myId && coupleReaction1 != .error {
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
  
  func tapQnAListItem(_ question: DBStaticQuestion) {
    selectedQuestion = question
    showQnASheet = true
  }
  
  func tapPlusButton() {
    showCategoryWayPointSheet = true
  }
}
