//
//  AnswerWriteViewModel.swift
//  ABloom
//
//  Created by yun on 10/26/23.
//

import SwiftUI

@MainActor
final class AnswerWriteViewModel: ObservableObject {
  @Published var answerText: String = ""
  @Published var isAlertOn: Bool = false
  @Published var sex = Bool()
  
  
  func getUserSex() async throws {
    let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
    
    let sex = try await UserManager.shared.getUser(userId: userId).sex
    
    // 0 = female, 1 = male
    self.sex = sex!
  }
  
  
  func moveToBack() {
    isAlertOn = true
  }
  
  func createAnswer(questionId: Int) throws {
    let user = try AuthenticationManager.shared.getAuthenticatedUser()
    try UserManager.shared.creatAnswer(userId: user.uid, questionId: questionId, content: answerText)
  }
}
