//
//  DBStaticQuestionModel.swift
//  ABloom
//
//  Created by 정승균 on 10/29/23.
//

import Foundation

/// DB에 저장된 Static Quesiton
struct DBStaticQuestion: Codable, Hashable {
  let questionID: Int
  let category: String
  let content: String
  
  init(questionID: Int, category: String, content: String) {
    self.questionID = questionID
    self.category = category
    self.content = content
  }
  
  enum CodingKeys: String, CodingKey {
    case questionID = "q_id"
    case category = "category"
    case content = "content"
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.questionID, forKey: .questionID)
    try container.encode(self.category, forKey: .category)
    try container.encode(self.content, forKey: .content)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.questionID = try container.decode(Int.self, forKey: .questionID)
    self.category = try container.decode(String.self, forKey: .category)
    self.content = try container.decode(String.self, forKey: .content)
  }
}
