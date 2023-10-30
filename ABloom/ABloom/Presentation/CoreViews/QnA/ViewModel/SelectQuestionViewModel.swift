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
  
  @Published var gender = Bool()
  
  
  func getUserGender() async throws {
    let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
    
    let gender = try await UserManager.shared.getUser(userId: userId).sex
    
    // 0 = female, 1 = male
    self.gender = gender!
  }
  
  
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
