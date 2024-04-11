//
//  SelectQuestionViewModel.swift
//  ABloom
//
//  Created by yun on 11/18/23.
//

import Combine
import SwiftUI


@MainActor
final class SelectQuestionViewModel: ObservableObject {
  @Published var questionLists = [DBStaticQuestion]()
  
  @Published var filteredLists = [DBStaticQuestion]()
  @Published var selectedQuestion: DBStaticQuestion? = nil
  @Published var isAnswerSheetOn = Bool()
  @Published var didGetCategory = Bool()
  @Published var selectedCategory: Category = Category.communication
  
  @AppStorage("isQuestionLabBtnActive") var isQuestionLabBtnActive = true

  private var cancellables = Set<AnyCancellable>()
  
  
  init() {
    self.fetchQuestions()
  }
  
  // 나 혹은 상대방이 답한 질문 제외한 질문리스트가 저장된 변수 그대로 받아오기
  private func fetchQuestions() {
    
    StaticQuestionManager.shared.$filteredQuestions
      .sink { [weak self] filteredQuestions in
        if let filteredQ = filteredQuestions {
          self?.questionLists = filteredQ
        }
      }
      .store(in: &cancellables)
    
    filterCategoryQuestion()
  }
  
  func updateSelectedCategory(new: Category) {
    self.selectedCategory = new
    filterCategoryQuestion()
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
  
  // 카테고리에 해당하는 질문만 리스트에 추가
  func filterCategoryQuestion() {
    filteredLists.removeAll()
    for question in self.questionLists {
      if question.category == selectedCategory.rawValue {
        filteredLists.append(question)
      }
    }
  }
}
