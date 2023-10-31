//
//  DBEssentialQuestionModel.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/31/23.
//

import Foundation

struct DBEssentialQuestion: Codable {
  let fixedOrder: [Int]
  let randomOrder: [Int]
  
  init(fixedOrder: [Int], randomOrder: [Int]) {
    self.fixedOrder = fixedOrder
    self.randomOrder = randomOrder
  }
  
  enum CodingKeys: String, CodingKey {
    case fixedOrder = "fixed_order"
    case randomOrder = "random_order"
   
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.fixedOrder = try container.decode([Int].self, forKey: .fixedOrder)
    self.randomOrder = try container.decode([Int].self, forKey: .randomOrder)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.fixedOrder, forKey: .fixedOrder)
    try container.encode(self.randomOrder, forKey: .randomOrder)
    
  }
}
