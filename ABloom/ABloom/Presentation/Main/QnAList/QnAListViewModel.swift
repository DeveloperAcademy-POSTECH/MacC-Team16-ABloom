//
//  QnAListViewModel.swift
//  ABloom
//
//  Created by Lee Jinhee on 11/19/23.
//

import SwiftUI

final class QnAListViewModel: ObservableObject {
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
    getUserInfo()
    getAnswers()
    getQuestions()
    if questions.isEmpty {
      viewState = .isEmpty
    } else {
      viewState = .isSorted
    }
  }
  
  func getUserInfo() {
    Task {
      try await UserManager.shared.fetchCurrentUser()
      try await UserManager.shared.fetchFianceUser()
      dump(UserManager.shared.currentUser)
      dump(UserManager.shared.fianceUser)
    }
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
