//
//  AnswerCheckViewModel.swift
//  ABloom
//
//  Created by 정승균 on 10/29/23.
//

import Foundation

@MainActor
final class AnswerCheckViewModel: ObservableObject {
  @Published var question: DBStaticQuestion? = nil
  @Published var fianceAnswer: String = ""
  @Published var myAnswer: String = ""
  @Published var isNoFiance = false
  @Published var isNoMyAnswer = false
  @Published var isNoFianceAnswer = false
  let questionId: Int
  
  init(fianceAnswer: String = "", myAnswer: String = "", questionId: Int) {
    self.fianceAnswer = fianceAnswer
    self.myAnswer = myAnswer
    self.questionId = questionId
  }
  
  func getAnswers() {
    // TODO: 상대방 응답
    Task {
      try? await getQuestion(by: self.questionId)
      try? await getMyAnswer()
      try? await getFianceAnswer()
    }
  }
  
  private func getMyAnswer() async throws {
    let myId = try AuthenticationManager.shared.getAuthenticatedUser().uid
    
    do {
      let myAnswer = try await UserManager.shared.getAnswer(userId: myId, questionId: questionId)
      self.myAnswer = myAnswer.answerContent
    } catch {
      self.isNoMyAnswer = true
      throw URLError(.badURL)
    }
  }
  
  private func getFianceAnswer() async throws {
    guard let fianceId = try await UserManager.shared.getCurrentUser().fiance else {
      self.isNoFiance = true
      throw URLError(.badServerResponse)
    }
    
    do {
      let fianceAnswer = try await UserManager.shared.getAnswer(userId: fianceId, questionId: questionId)
      self.fianceAnswer = fianceAnswer.answerContent
    } catch {
      self.isNoFianceAnswer = true
      throw URLError(.badURL)
    }
  }
  
  private func getQuestion(by id: Int) async throws {
    self.question = try await StaticQuestionManager.shared.getQuestionById(id: id)
  }
}
