//
//  CategoryWaypointViewModel.swift
//  ABloom
//
//  Created by yun on 11/18/23.
//

import SwiftUI

final class CategoryWaypointViewModel: ObservableObject {
  
  @Published var isAnswered: Bool = false
  @Published var recommendQuestion: DBStaticQuestion = .init(questionID: 3, category: "", content: "추천질문입니다")
  @Published var selectedCategory: Category = Category.communication
  @Published var isSelectSheetOn = Bool()

  
  func isClicked(selectedCategory: Category) {
    self.selectedCategory = selectedCategory
    self.isSelectSheetOn.toggle()
  }
  
//  @AppStorage("savedRecommendQuestionId") var savedRecommendQuestionId: Int = 3
//  @AppStorage("lastQuestionChangeDate") var lastQuestionChangeDate: Date = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
//  
//  private func loadRecommendedQuestion() async throws {
//    let user = try await UserManager.shared.getCurrentUser()
//    let currentDate = Date.now
//    
//    if currentDate.isSameDate(lastChangedDate: lastQuestionChangeDate) {
//      self.recommendQuestion = try await StaticQuestionManager.shared.getQuestionById(id: savedRecommendQuestionId)
//    } else {
//      self.recommendQuestion = try await getQuestionsRecommend(userId: user.userId, fianceId: user.fiance)
//      lastQuestionChangeDate = currentDate
//    }
//    
//    self.recommendQuestionAnswered = try await checkRecommendAnswered(user: user, questionId: recommendQuestion.questionID)
//  }
//  
//  /**
//   둘다 답하지 않은 질문들 중에서 essential Question에 해당하는 questionID를 찾아서 question을 반환하는 함수
//  */
//  private func getQuestionsRecommend(userId: String, fianceId: String?) async throws -> DBStaticQuestion {
//    
//    try await StaticQuestionManager.shared.fetchEssentialCollections()
//    let questions = try await StaticQuestionManager.shared.getQuestionsWithoutAnswers(myId: userId, fianceId: fianceId)
//    
//    let essentialOrderList = StaticQuestionManager.shared.essentialQuestionsOrder
//    let essentialRandomList = StaticQuestionManager.shared.essentialQuestionsRandom
//    
//    for essentialquestion in essentialOrderList {
//      for question in questions {
//        if essentialquestion == question.questionID {
//          savedRecommendQuestionId = question.questionID
//          return question
//        }
//      }
//    }
//    
//    for essentialQuestion in essentialRandomList {
//      for question in questions {
//        if essentialQuestion == question.questionID {
//          savedRecommendQuestionId = question.questionID
//          return question
//        }
//      }
//    }
//    
//    let randomQuestion = questions.randomElement()!
//    savedRecommendQuestionId = randomQuestion.questionID
//    
//    return randomQuestion
//  }
//  
//  func checkRecommendAnswered(user: DBUser, questionId: Int) async throws -> Bool {
//    do {
//      let answer = try await UserManager.shared.getAnswer(userId: user.userId, questionId: questionId)
//      return true
//    } catch {
//      return false
//    }
//  }
  
}

#Preview {
  CategoryWaypointView()
}
