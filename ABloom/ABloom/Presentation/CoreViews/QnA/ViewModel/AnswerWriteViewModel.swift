//
//  AnswerWriteViewModel.swift
//  ABloom
//
//  Created by yun on 10/26/23.
//

import SwiftUI

class AnswerWriteViewModel: ObservableObject {
  @Published var answerText: String = ""
  
  func createAnswer(questionId: Int) throws {
    let user = try AuthenticationManager.shared.getAuthenticatedUser()
    try UserManager.shared.creatAnswer(userId: user.uid, questionId: questionId, content: answerText)
  }
}
