//
//  QuestionMainViewModel.swift
//  ABloom
//
//  Created by yun on 10/22/23.
//

import SwiftUI

enum Category: String, CaseIterable {
  case communication
  case values
  case finance
  case lifestyle
  case child
  case family
  case sex
  case health
  case wedding
  case future
  case present
  case past
  
  
  
  var type: String {
    switch self {
    case .communication: return "소통"
    case .values: return "가치관"
    case .finance: return "경제"
    case .lifestyle: return "생활"
    case .child: return "자녀"
    case .family: return "가족"
    case .sex: return "부부 관계"
    case .health: return "건강"
    case .wedding: return "결혼 준비"
    case .future: return "미래"
    case .present: return "현재"
    case .past: return "과거"
    
    }
  }
  
  
  var imgName: String {
    switch self {
    case .communication: 
      return "circleIcon_isometric_chatting"
    case .values:
      return "circleIcon_isometic_star"
    case .finance:
      return "circleIcon_isometic_money"
    case .lifestyle:
      return "circleIcon_isometic_rice"
    case .child:
      return "circleIcon_isometic_dummy"
    case .family:
      return "circleIcon_isometic_sofa"
    case .sex:
      return "circleIcon_isometic_bed"
    case .health:
      return "circleIcon_isometic_health"
    case .wedding:
      return "circleIcon_isometic_love_calender"
    case .future:
      return "circleIcon_isometic_target"
    case .present:
      return "circleIcon_isometric_location"
    case .past:
      return "circleIcon_isometic_reversed_timer"
    }
  }
}

@MainActor
final class QuestionMainViewModel: ObservableObject {
  @Published var answers: [DBAnswer] = []
  @Published var questions: [DBStaticQuestion] = []
  @Published var sex = Bool()
  
  
  func getUserSex() async throws {
    let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
    
    let sex = try await UserManager.shared.getUser(userId: userId).sex
    
    // 0 = female, 1 = male
    self.sex = sex!
  }
  
  func getInfo() {
    clearAll()
    Task {
      try? await getMyAnswers()
      try? await getFianceAnswers()
      distinctQuestions()
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
  
  private func clearAll() {
    self.answers = []
    self.questions = []
  }
  
  private func sortAnswers() {
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
