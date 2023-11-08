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
  @Published var fianceAnswerId: String?
  @Published var fianceAnswer: DBAnswer?
  @Published var fianceName: String = ""
  
  @Published var myId: String?
  @Published var fianceId: String?
  
  @Published var isNoFiance = false
  @Published var isNoMyAnswer = false
  @Published var isNoFianceAnswer = false
  @Published var isDataReady = false
  
  // TODO: @Radin 아래 플래그들을 이용하여 뷰 작업을 진행해주세요
  // 1. 나의 반응과 피앙새의 반응이 모두 있을 때 (hasMyReaction && hasFianceReaction)
  // 2. 나의 반응만 있을 때 (hasMyReaction)
  // 3. 피앙새의 반응만 있을 때 (hasFianceReaction)
  // 4. 둘 다 반응이 없을 때 (else)
  @Published var hasMyReaction = false
  @Published var hasFianceReaction = false
  @Published var bothPositiveReaction = false
  
  
  // TODO: @Radin 아래 플래그들을 이용하여 뷰 작업을 진행해주세요
  // 1. 나와 피앙새 모두 문답을 완료 표시 했을 때 (isCompleteMyAnswer && isCompleteFianceAnswer)
  // 2. 나만 문답 완료 표시를 했을 때 (isCompleteMyAnswer)
  // 3. 피앙새만 문답 완료 표시를 했을 때 (isCompleteFianceAnswer)
  // 4. 둘 다 문답 완료를 하지 않았을 때 (else)
  @Published var isCompleteMyAnswer = false
  @Published var isCompleteFianceAnswer = false
  
  let questionId: Int
  
  let notConnectedText = "아직 상대방과 연결되어 있지 않아요. 지금 연결하고, 상대방의 문답을 확인해주세요."
  let waitText = "상대방의 답변을 기다리고 있어요."
  
  
  init(questionId: Int) {
    self.questionId = questionId
  }
  
  func getAnswers() {
    self.isDataReady = false

    Task {
      try? await getQuestion(by: self.questionId)
      try? await getMyAnswer()
      try? await getFianceAnswer()
      checkReactions()
      checkAnswersComplete()
      self.isDataReady = true
    }
  }
  
  private func getMyAnswer() async throws {
    let myId = try AuthenticationManager.shared.getAuthenticatedUser().uid
    
    self.myId = myId
    
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
    
    self.fianceId = fianceId
    
    do {
      let fianceAnswer = try await UserManager.shared.getAnswer(userId: fianceId, questionId: questionId)
      self.fianceAnswer = fianceAnswer.answer
      self.fianceAnswerId = fianceAnswer.answerId
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
  
  // MARK: 반응(React)관련 함수
  // TODO: @Radin 이 함수를 이용하여 버튼과 액션을 구현해주세요.
  func reactToAnswer(reaction: ReactionType) throws {
    guard let myId = self.myId else { throw URLError(.badURL) }
    
    guard let myAnswer = self.myAnswer else { throw URLError(.badURL) }
    guard let myAnswerId = self.myAnswerId else { throw URLError(.badURL)}
    
    UserManager.shared.updateReaction(userId: myId, answerId: myAnswerId, reaction: reaction)
    
    Task {
      try? await getMyAnswer()
      try? await getFianceAnswer()
      checkReactionType()
      getAnswers()
    }
  }
  
  private func checkReactions() {
    let isMyAnswerPositive = checkMyReaction()
    let isFianceAnswerPositive = checkFianceReaction()
    
    if isMyAnswerPositive && isFianceAnswerPositive {
      self.bothPositiveReaction = true
    }
  }
  
  private func checkMyReaction() -> Bool {
    guard let myAnswerReaction = self.myAnswer?.reactionType else { return false }

    if myAnswerReaction != .error {
      self.hasMyReaction = true
    }
    
    return myAnswerReaction.isPositiveReact()
  }
  
  private func checkFianceReaction() -> Bool {
    guard let fianceAnswerReaction = self.fianceAnswer?.reactionType else { return false }
    
    if fianceAnswerReaction != .error {
      self.hasFianceReaction = true
    }
    
    return fianceAnswerReaction.isPositiveReact()
  }
  
  private func checkReactionType() {
    guard let myAnswerReaction = self.myAnswer?.reactionType else { return }
    guard let fianceAnswerReaction = self.fianceAnswer?.reactionType else { return }
    
    print(myAnswerReaction)
    print(fianceAnswerReaction)
    
    if myAnswerReaction.isPositiveReact() && fianceAnswerReaction.isPositiveReact() {
      // 둘 다 긍정일 때 : isComplete = true
      guard let myId = self.myId else { return }
      guard let fianceId = self.fianceId else { return }
      guard let myAnswerId = self.myAnswerId else { return }
      guard let fianceAnswerId = self.fianceAnswerId else { return }
      
      UserManager.shared.updateAnswerComplete(userId: myId, answerId: myAnswerId)
      UserManager.shared.updateAnswerComplete(userId: fianceId, answerId: fianceAnswerId)
    }
  }
  
  
  // MARK: 문답 완료(isComplete)관련 함수
  // TODO: @Radin 이 함수를 이용하여 버튼과 액션을 구현해주세요.
  func completeAnswer() throws {
    guard let myId = self.myId else { throw URLError(.badURL) }
    guard let myAnswerId = self.myAnswerId else { throw URLError(.badURL)}
    
    UserManager.shared.updateAnswerComplete(userId: myId, answerId: myAnswerId)
    
    getAnswers()
  }
  
  private func checkAnswersComplete() {
    checkMyAnswerComplete()
    checkFianceAnswerComplete()
  }
  
  private func checkMyAnswerComplete() {
    guard let myAnswerIsComplete = self.myAnswer?.isComplete else { return }
    
    self.isCompleteMyAnswer = myAnswerIsComplete
  }
  
  private func checkFianceAnswerComplete() {
    guard let fianceAnswerIsComplete = self.fianceAnswer?.isComplete else { return }
    
    self.isCompleteFianceAnswer = fianceAnswerIsComplete
  }
}
