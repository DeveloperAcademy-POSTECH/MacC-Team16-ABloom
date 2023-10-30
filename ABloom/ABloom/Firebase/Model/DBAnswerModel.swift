//
//  DBAnswerModel.swift
//  ABloom
//
//  Created by 정승균 on 10/29/23.
//

import Foundation

struct DBAnswer: Codable {
  let questionId: Int
  let date: Date
  let answerContent: String
  
  init(questionId: Int, date: Date = .now, answerContent: String) {
    self.questionId = questionId
    self.date = date
    self.answerContent = answerContent
  }
  
  enum CodingKeys: String, CodingKey {
    case questionId = "q_id"
    case date = "date"
    case answerContent = "answer_content"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.questionId = try container.decode(Int.self, forKey: .questionId)
    self.date = try container.decode(Date.self, forKey: .date)
    self.answerContent = try container.decode(String.self, forKey: .answerContent)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.questionId, forKey: .questionId)
    try container.encode(self.date, forKey: .date)
    try container.encode(self.answerContent, forKey: .answerContent)
  }
}
