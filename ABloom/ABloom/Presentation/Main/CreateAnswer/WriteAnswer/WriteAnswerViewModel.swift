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
  @Published var textNum: Int = 0
  
  func backClicked() {
    if self.ansText != "" {
      self.isCancelAlertOn.toggle()
    } 
  }
  
  func completeClicked() {
    self.isCompleteAlertOn.toggle()
  }
  
  func updateTextNum(num: Int) {
    self.textNum = num
  }
  
}
