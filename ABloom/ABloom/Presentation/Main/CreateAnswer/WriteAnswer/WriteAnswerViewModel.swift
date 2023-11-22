//
//  WriteAnswerViewModel.swift
//  ABloom
//
//  Created by yun on 11/20/23.
//

import SwiftUI

@MainActor
class WriteAnswerViewModel: ObservableObject {
  @Published var isCancelAlertOn = Bool()
  @Published var isCompleteAlertOn = Bool()
  @Published var ansText: String = ""
  @Published var isTextOver = Bool()
  @Published var isSwipeEnabled = Bool()
  
  func checkTextCount() {
    if self.ansText.count > 150 {
      self.isTextOver = true
    } else {
      self.isTextOver = false
    }
    
    self.checkSwipeDisable()
  }
  
  func swipeEnable() {
    self.isSwipeEnabled = true
  }
  
  // 백스와이프 차단
  private func checkSwipeDisable() {
    if self.ansText == "" {
      self.isSwipeEnabled = true
    } else {
      self.isSwipeEnabled = false
    }
  }
  
  func backClicked() {
    if self.ansText != "" {
      self.isCancelAlertOn.toggle()
    } 
  }
  
  func completeClicked() {
    self.isCompleteAlertOn.toggle()
  }
  
  func saveAnswer(qid: Int) throws {
    let uid = try AuthenticationManager.shared.getAuthenticatedUser().uid
    try AnswerManager.shared.creatAnswer(userId: uid, questionId: qid, content: self.ansText)
  }
  
}
