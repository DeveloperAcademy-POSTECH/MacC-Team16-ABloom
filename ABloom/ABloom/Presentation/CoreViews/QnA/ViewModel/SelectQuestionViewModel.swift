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
  @Published var selectedCategory: Category = Category.values
  
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
    let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
    self.questionLists = try await StaticQuestionManager.shared.getQuestionsWithoutAnswers(userId: userId)
    filterQuestion()
  }
}
