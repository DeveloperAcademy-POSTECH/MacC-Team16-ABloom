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
  @Published var selectedCategory: Category = Category.communication
  
  
  func questionClicked(selectedQ: DBStaticQuestion) {
    self.selectedQuestion = selectedQ
    self.isAnswerSheetOn.toggle()
  }
  
  func selectCategory(seleted: Category) {
    selectedCategory = seleted
    filterCategoryQuestion()
  }
  
  // 나 혹은 상대방이 답한 질문 제외한 질문리스트가 저장된 변수 그대로 받아오기
  func fetchQuestions() { 
    if let filteredQuestions = StaticQuestionManager.shared.filteredQuestions {
      self.questionLists = filteredQuestions
    } else {
      // 로그인 안되어 있어서 데이터를 못받아올 경우 
      self.questionLists = previewQuestions
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
  
  // MARK: - oldVersion
  func fetchQuestionsOriginal() async throws {
    let user = try await UserManager.shared.getCurrentUser()
    self.questionLists = try await StaticQuestionManager.shared.getQuestionsWithoutAnswers(myId: user.userId, fianceId: user.fiance)
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
  
  
}

#Preview {
  SelectQuestionView()
}
