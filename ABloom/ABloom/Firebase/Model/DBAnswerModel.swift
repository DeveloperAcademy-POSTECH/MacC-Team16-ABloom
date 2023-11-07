//
//  DBAnswerModel.swift
//  ABloom
//
//  Created by 정승균 on 10/29/23.
//

import Foundation

struct DBAnswer: Codable {
  let questionId: Int
  let userId: String
  let date: Date
  let answerContent: String
  let isComplete: Bool?
  let reaction: Int?
  
  init(questionId: Int, userId: String, date: Date = .now, answerContent: String, isComplete: Bool, reaction: Int?) {
    self.questionId = questionId
    self.userId = userId
    self.date = date
    self.answerContent = answerContent
    self.isComplete = isComplete
    self.reaction = reaction
  }
  
  enum CodingKeys: String, CodingKey {
    case questionId = "q_id"
    case userId = "user_id"
    case date = "date"
    case answerContent = "answer_content"
    case isComplete = "is_complete"
    case reaction = "reaction"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.questionId = try container.decode(Int.self, forKey: .questionId)
    self.userId = try container.decode(String.self, forKey: .userId)
    self.date = try container.decode(Date.self, forKey: .date)
    self.answerContent = try container.decode(String.self, forKey: .answerContent)
    self.isComplete = try container.decodeIfPresent(Bool.self, forKey: .isComplete)
    self.reaction = try container.decodeIfPresent(Int.self, forKey: .reaction)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.questionId, forKey: .questionId)
    try container.encode(self.userId, forKey: .userId)
    try container.encode(self.date, forKey: .date)
    try container.encode(self.answerContent, forKey: .answerContent)
    try container.encode(self.isComplete, forKey: .isComplete)
    try container.encode(self.reaction, forKey: .reaction)
  }
}
