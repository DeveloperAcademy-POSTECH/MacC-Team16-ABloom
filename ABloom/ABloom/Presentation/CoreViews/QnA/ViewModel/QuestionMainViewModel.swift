//
//  QuestionMainViewModel.swift
//  ABloom
//
//  Created by yun on 10/22/23.
//

import SwiftUI

@MainActor
final class QuestionMainViewModel: ObservableObject {
  @Published var answers: [DBAnswer] = []
  @Published var questions: [DBStaticQuestion] = []
  @Published var sex = Bool()
  @Published var viewState: ViewState = .isProgress
  
  enum ViewState {
    case isProgress
    case isEmpty
    case isSorted
  }
  
  func getUserSex() async throws {
    let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
    
    let sex = try await UserManager.shared.getUser(userId: userId).sex
    
    // 0 = female, 1 = male
    self.sex = sex!
  }
  
  func getInfo() {
    self.viewState = .isProgress
    clearAll()
    Task {
      try? await getUserSex()
      try? await getMyAnswers()
      try? await getFianceAnswers()
      distinctQuestions()
      checkQuestions()
      sortAnswers()
    }
  }
  
  func checkAnswerStatus(qid: Int) -> AnswerStatus {
    let filteredAnswers = answers.filter { $0.questionId == qid }
    
    if filteredAnswers.count == 1 {
      guard let myId = try? AuthenticationManager.shared.getAuthenticatedUser().uid else { return .nobody }
      
      if filteredAnswers.first!.userId == myId {
        return .onlyMe
      } else {
        return .onlyFinace
      }
    } else if filteredAnswers.count == 2 {
      return .both
    } else {
      return .nobody
    }
  }
  
  private func checkQuestions() {
    self.viewState = self.questions.isEmpty ? .isEmpty : viewState
  }
  
  private func clearAll() {
    self.answers.removeAll()
    self.questions.removeAll()
  }
  
  private func sortAnswers() {
    if self.viewState == .isEmpty { return }
    
    self.answers.sort { $0.date > $1.date }
    
    let id = answers.map { $0.questionId }.uniqued()
    
    var newArray: [DBStaticQuestion] = []
    
    for i in id {
      for j in self.questions {
        if i == j.questionID {
          newArray.append(j)
        }
      }
    }
    
    self.questions = newArray
    self.viewState = .isSorted
  }
  
  private func distinctQuestions() {
    self.questions = self.questions.uniqued()
  }
  
  private func getMyAnswers() async throws {
    let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
    
    let myAnswers = try await UserManager.shared.getAnswers(userId: userId)
    let questions = try await StaticQuestionManager.shared.getAnsweredQuestions(questionIds: myAnswers.map({ $0.questionId }))
    
    self.answers += myAnswers
    self.questions += questions
  }
  
  private func getFianceAnswers() async throws {
    guard let userId = try await UserManager.shared.getCurrentUser().fiance else { throw URLError(.badURL) }
    
    let fianceAnswers = try await UserManager.shared.getAnswers(userId: userId)
    let questions = try await StaticQuestionManager.shared.getAnsweredQuestions(questionIds: fianceAnswers.map({ $0.questionId }))
    
    self.answers += fianceAnswers
    self.questions += questions
  }
}
