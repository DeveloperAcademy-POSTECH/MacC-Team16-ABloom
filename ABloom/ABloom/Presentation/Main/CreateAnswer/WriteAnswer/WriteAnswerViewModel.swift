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
    if self.ansText.count > 150 {
      self.isTextOver = true
    } else {
      self.isTextOver = false
    }
    
    self.checkSwipeDisable()
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
  
  
}
