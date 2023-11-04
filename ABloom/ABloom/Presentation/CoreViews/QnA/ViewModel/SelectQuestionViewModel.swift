//
//  SelectQuestionViewModel.swift
//  ABloom
//
//  Created by yun on 10/25/23.
//

import SwiftUI


@MainActor
final class SelectQuestionViewModel: ObservableObject {
  @Published var questionLists = [DBStaticQuestion]()
  @Published var filteredLists = [DBStaticQuestion]()
  @Published var selectedCategory: Category = Category.communication
  @Published var isReady = Bool()
  
  func selectCategory(seleted: Category) {
    selectedCategory = seleted
    filterQuestion()
  }
  
  func filterQuestion() {
    filteredLists.removeAll()
    for question in questionLists {
      if question.category == selectedCategory.rawValue {
        filteredLists.append(question)
      }
    }
  }
  
  func fetchQuestions() async throws {
    let user = try await UserManager.shared.getCurrentUser()
    self.questionLists = try await StaticQuestionManager.shared.getQuestionsWithoutAnswers(myId: user.userId, fianceId: user.fiance)
    filterQuestion()
    self.isReady = true
  }
}
