//
//  QuestionMainViewModel.swift
//  ABloom
//
//  Created by yun on 10/22/23.
//

import SwiftUI

enum Category: String, CaseIterable {
  case values
  case health
  case finance
  case family
  case couple
  case past
  case lifeStyle
  
  
  var type: String {
    switch self {
    case .values: return "가치관"
    case .health: return "건강"
    case .finance: return "경제"
    case .family: return "가족"
    case .couple: return "부부관계"
    case .past: return "과거"
    case .lifeStyle: return "생활"
    }
  }
  
  
  var imgName: String {
    switch self {
    case .values:
      return "circleIcon_isometic_star"
    case .health:
      return "circleIcon_isometic_health"
    case .finance:
      return "circleIcon_isometic_money"
    case .family:
      return "circleIcon_isometic_sofa"
    case .couple:
      return "circleIcon_isometic_bed"
    case .past:
      return "circleIcon_isometic_reversed_timer"
    case .lifeStyle:
      return "circleIcon_isometic_rice"
    }
  }
}

@MainActor
final class QuestionMainViewModel: ObservableObject {
  @Published var answers: [DBAnswer] = []
  @Published var questions: [DBStaticQuestion] = []
  
  func getInfo() {
    Task {
      try? await getMyAnswers()
      try? await getFianceAnswers()
      distinctQuestions()
      sortAnswers()
    }
  }
  
  func sortAnswers() {
    self.answers.sort { answer1, answer2 in
      answer1.date > answer2.date
    }
    
    let id = answers.map { answer in
      answer.questionId
    }
    
    let distinctId = id.uniqued()
    
    var newArray:[DBStaticQuestion] = []
    
    for i in distinctId {
      for j in self.questions {
        if i == j.questionID {
          newArray.append(j)
        }
      }
    }
    
    self.questions = newArray
  }
  
  func distinctQuestions() {
    self.questions = self.questions.uniqued()
  }
  
  private func getMyAnswers() async throws {
    let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
    
    let myAnswers = try await UserManager.shared.getAnswers(userId: userId)
    let questions = try await StaticQuestionManager.shared.getAnsweredQuestions(questionIds: myAnswers.map({ $0.questionId }))
    
    myAnswers.forEach { answer in
      self.answers.append(answer)
    }
    questions.forEach { question in
      self.questions.append(question)
    }
  }
  
  private func getFianceAnswers() async throws {
    guard let userId = try await UserManager.shared.getCurrentUser().fiance else { throw URLError(.badURL)}
    
    let fianceAnswers = try await UserManager.shared.getAnswers(userId: userId)
    let questions = try await StaticQuestionManager.shared.getAnsweredQuestions(questionIds: fianceAnswers.map({ $0.questionId }))
    
    fianceAnswers.forEach { answer in
      self.answers.append(answer)
    }
    
    questions.forEach { question in
      self.questions.append(question)
    }
  }
}
