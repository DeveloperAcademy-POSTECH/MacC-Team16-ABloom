//
//  QnAListViewModel.swift
//  ABloom
//
//  Created by Lee Jinhee on 11/19/23.
//

import SwiftUI

final class QnAListViewModel: ObservableObject {
  @Published var currentUser: DBUser?
  @Published var answers: [DBAnswer] = []
  @Published var questions: [DBStaticQuestion] = []
  @Published var viewState: QnAListViewState = .isProgress

  @Published var showProfileSheet: Bool = false
  @Published var showQnASheet: Bool = false
  @Published var showCategoryWayPointSheet: Bool = false
  
  enum QnAListViewState {
    case isProgress
    case isEmpty
    case isSorted
  }
  
  init() {
    getUser()
    getAnswers()
    getQuestions()
    if questions.isEmpty {
      viewState = .isEmpty
    } else {
      viewState = .isSorted
    }
  }
  
  func getUser() {
    self.currentUser = UserManager.shared.currentUser
  }
  
  func tapProfileButton() {
    showProfileSheet = true
  }
  
  func tapQnAListItem() {
    showQnASheet = true
  }
  
  func tapPlusButton() {
    showCategoryWayPointSheet = true
  }
  
  func checkAnswerStatus(qid: Int) -> AnswerStatus {
    return .completed
  }
  
  func getAnswers() {
    
  }
  
  func getQuestions() {
    
  }
}
