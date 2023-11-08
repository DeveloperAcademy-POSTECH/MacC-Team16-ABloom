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
  @Published var myAnswerId: String?
  @Published var myAnswer: DBAnswer?
  @Published var fianceAnswer: DBAnswer?
  @Published var fianceName: String = ""
  
  @Published var isNoFiance = false
  @Published var isNoMyAnswer = false
  @Published var isNoFianceAnswer = false
  @Published var isDataReady = false
  
  let questionId: Int
  
  let notConnectedText = "아직 상대방과 연결되어 있지 않아요. 지금 연결하고, 상대방의 문답을 확인해주세요."
  let waitText = "상대방의 답변을 기다리고 있어요."
  
  
  init(questionId: Int) {
    self.questionId = questionId
  }
  
  func getAnswers() {
    self.isDataReady = false
    // TODO: 상대방 응답
    Task {
      try? await getQuestion(by: self.questionId)
      try? await getMyAnswer()
      try? await getFianceAnswer()
      self.isDataReady = true
    }
  }
  
  private func getMyAnswer() async throws {
    let myId = try AuthenticationManager.shared.getAuthenticatedUser().uid
    
    do {
      let myAnswer = try await UserManager.shared.getAnswer(userId: myId, questionId: questionId)
      self.myAnswer = myAnswer.answer
      self.myAnswerId = myAnswer.answerId
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
      self.fianceAnswer = fianceAnswer.answer
      if let fianceName = try await UserManager.shared.getUser(userId: fianceId).name {
        self.fianceName = fianceName
      }
    } catch {
      self.isNoFianceAnswer = true
      throw URLError(.badURL)
    }
  }
  
  private func getQuestion(by id: Int) async throws {
    self.question = try await StaticQuestionManager.shared.getQuestionById(id: id)
  }
  
  func reactToAnswer(reaction: ReactionType) throws {
    let myId = try AuthenticationManager.shared.getAuthenticatedUser().uid
    
    
    guard let myAnswer = myAnswer else { throw URLError(.badURL) }
    guard let myAnswerId = myAnswerId else { throw URLError(.badURL)}
    
    UserManager.shared.updateReaction(userId: myId, answerId: myAnswerId, reaction: reaction)
  }
}
