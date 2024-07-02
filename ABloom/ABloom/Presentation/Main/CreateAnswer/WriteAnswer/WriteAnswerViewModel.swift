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
  
  
  func checkTextCount() {
    // 맥시멈 제한
    if self.ansText.count >= 200 {
      self.ansText = String(self.ansText.prefix(200))
    }
    
    if self.ansText.count > 150 {
      self.isTextOver = true
    } else {
      self.isTextOver = false
    }
    
    self.checkSwipeDisable()
  }
  
  func swipeEnable() {
    UINavigationController.isSwipeBackEnabled = true
  }
  
  // 백스와이프 차단
  private func checkSwipeDisable() {
    if self.ansText == "" {
      UINavigationController.isSwipeBackEnabled = true
    } else {
      UINavigationController.isSwipeBackEnabled = false
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
  
  func createAnswer(qid: Int, category: String) throws {
    let uid = try AuthenticationManager.shared.getAuthenticatedUser().uid
    try AnswerManager.shared.createAnswer(userId: uid, questionId: qid, content: self.ansText)
    MixpanelManager.qnaAnswer(letterCount: ansText.count, category: category, questionId: qid)
  }
}
