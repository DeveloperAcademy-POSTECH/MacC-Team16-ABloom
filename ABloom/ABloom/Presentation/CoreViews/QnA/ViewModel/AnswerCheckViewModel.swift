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
  let questionId: Int
  
  init(fianceAnswer: String = "", myAnswer: String = "", questionId: Int) {
    self.fianceAnswer = fianceAnswer
    self.myAnswer = myAnswer
    self.questionId = questionId
  }
  
  func getAnswers() {
    // TODO: 나의 응답, 상대방 응답
    Task {
      try? await getQuestion(by: self.questionId)
      try? await getMyAnswer()
      getFianceAnswer()
    }
  }
  
  private func getMyAnswer() async throws {
    // TODO: 내 응답 불러오기
    let myId = try AuthenticationManager.shared.getAuthenticatedUser().uid
    let myAnswer = try await UserManager.shared.getAnswer(userId: myId, questionId: questionId)
    
    self.myAnswer = myAnswer.answerContent
  }
  
  private func getFianceAnswer() {
    // TODO: 상대방 응답 불러오기
    
  }
  
  private func getQuestion(by id: Int) async throws {
    // TODO: 질문 불러오기
    self.question = try await StaticQuestionManager.shared.getQuestionById(id: id)
  }
}
