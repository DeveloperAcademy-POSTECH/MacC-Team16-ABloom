//
//  CategoryWaypointViewModel.swift
//  ABloom
//
//  Created by yun on 11/18/23.
//

import Combine
import SwiftUI

enum RecommendedStatus {
  case notLoggedIn
  case notAnswered
  case answered
  case none
}


@MainActor
final class CategoryWaypointViewModel: ObservableObject {
  
  @AppStorage("lastQuestionChangeDate") var lastQuestionChangeDate: Date = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
  
  // TODO: 차후 user Field로 생성하기
  @AppStorage("savedRecommendQuestionId") var savedRecommendQuestionId: Int = 3
  
  @Published var essentials: [Int]? = nil
  @Published var filteredQuestionsId: [Int]? = nil
  @Published var myAnswersId: [Int]? = nil
  @Published var filteredQuestions: [DBStaticQuestion]? = nil
  
   
  @Published var recommendQuestion: DBStaticQuestion = .init(questionID: 38, category: "finance", content: "결혼을 하게 되면 어떤 방식으로 돈을 관리하는게 좋을까?")
  @Published var recommendedQid: Int = 38
  
  @Published var selectedCategory: Category = Category.communication
  @Published var isSelectSheetOn = Bool()
  
  @Published var isRecommenedNavOn = Bool()
  
  @Published var questionStatus: RecommendedStatus = .none
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    self.fetchInformation()
  }
  
  private func fetchInformation() {
    
    if let essentials = EssentialQuestionManager.shared.essentialQuestions {
      self.essentials = essentials
    } else {
      questionStatus = .notLoggedIn
    }
    
    StaticQuestionManager.shared.$filteredQuestions
      .sink { [weak self] filteredQuestions in
        if let fileredQ = filteredQuestions {
          self?.filteredQuestionsId = fileredQ.map { $0.questionID }
        }
      }
      .store(in: &cancellables)
    
    AnswerManager.shared.$myAnswers
      .sink { [weak self] myAnswers in
        if let myAns = myAnswers {
          self?.myAnswersId = myAns.map { $0.questionId }
        }
      }
      .store(in: &cancellables)
  }
  
  func isClicked(selectedCategory: Category) {
    self.selectedCategory = selectedCategory
    self.isSelectSheetOn.toggle()
  }
  
  func recommenedQClicked() {
    self.isRecommenedNavOn.toggle()
  }
  
  func loadRecommendedQuestion() async throws {
    let currentDate = Date.now
  
    
    if currentDate.isSameDate(lastChangedDate: lastQuestionChangeDate) {
      // 하루가 지나지 않았을 경우 그대로 가져옴
      self.recommendQuestion = try await StaticQuestionManager.shared.getQuestionById(id: savedRecommendQuestionId)
    } else { // 하루가 지났을 경우 없데이트
      if self.essentials != nil {
        if self.checkAvailable() {
          self.recommendQuestion = try await StaticQuestionManager.shared.getQuestionById(id: self.recommendedQid)
          lastQuestionChangeDate = currentDate
        }
      }
    }
    checkIfAnswered()
  }
  
  // 둘 다 답변하지 않은 질문인지 확인
  private func checkAvailable() -> Bool {
    self.recommendedQid = (self.essentials?.randomElement())!
    
    if let ids = self.filteredQuestionsId {
      if ids.contains(recommendedQid) {
        return true
      } else { return checkAvailable() }
    }
    return true
  }
  
  
  private func checkIfAnswered() {
    if let myAnswersId = self.myAnswersId {
      if myAnswersId.contains(self.recommendedQid) {
        questionStatus = .answered
      } else {
        questionStatus = .notAnswered
      }
    }
  }
}
