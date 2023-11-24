//
//  SelectQuestionViewModel.swift
//  ABloom
//
//  Created by yun on 11/18/23.
//

import SwiftUI

@MainActor
final class SelectQuestionViewModel: ObservableObject {
  @Published var questionLists = [DBStaticQuestion]()
  @Published var filteredLists = [DBStaticQuestion]()
  @Published var selectedQuestion: DBStaticQuestion? = nil
  @Published var isAnswerSheetOn = Bool()
  @Published var didGetCategory = Bool()
  @Published var isLoggedIn = Bool()
  @Published var selectedCategory: Category = Category.communication
  
  
  init() {
    self.fetchQuestions()
  }
  
  func updateSelectedCategory(new: Category) {
    self.selectedCategory = new
    self.didGetCategory = true
  }

  
  func questionClicked(selectedQ: DBStaticQuestion) {
    self.selectedQuestion = selectedQ
    self.isAnswerSheetOn.toggle()
  }
  
  func selectCategory(seleted: Category) {
    selectedCategory = seleted
    filterCategoryQuestion()
  }
  
  // 나 혹은 상대방이 답한 질문 제외한 질문리스트가 저장된 변수 그대로 받아오기
  private func fetchQuestions() { 
    if let filteredQuestions = StaticQuestionManager.shared.filteredQuestions {
      self.questionLists = filteredQuestions
      self.isLoggedIn = true
    } else {
      self.isLoggedIn = false
    }
    filterCategoryQuestion()
  }
  
  // 카테고리에 해당하는 질문만 리스트에 추가
  func filterCategoryQuestion() {
    filteredLists.removeAll()
    for question in questionLists {
      if question.category == selectedCategory.rawValue {
        filteredLists.append(question)
      }
    }
  }
}
