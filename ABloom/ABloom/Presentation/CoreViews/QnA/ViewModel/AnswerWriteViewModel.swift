//
//  AnswerWriteViewModel.swift
//  ABloom
//
//  Created by yun on 10/26/23.
//

import SwiftUI

class AnswerWriteViewModel: ObservableObject {
  @Published var answerText: String = ""
  @Published var isAlertOn: Bool = false
  
  func moveToBack() {
    isAlertOn.toggle()
  }
  
  // 문답 저장
  func saveAns() {
    
  }
}
