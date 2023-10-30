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
  @Published var myAnwsers: [DBAnswer] = []
  @Published var questions: [DBStaticQuestion] = []
  @Published var gender = Bool()
  
  
  func getUserGender() async throws {
    let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
    
    let gender = try await UserManager.shared.getUser(userId: userId).sex
    
    // 0 = female, 1 = male
    self.gender = gender!
  }
  
  func getMyAnswers() async throws {
    let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
    
    let myAnswers = try await UserManager.shared.getAnswers(userId: userId)
    let questions = try await StaticQuestionManager.shared.getAnsweredQuestions(questionIds: myAnswers.map({ $0.questionId }))
    
    self.myAnwsers = myAnswers
    self.questions = questions
  }
}
