//
//  DBEssentialQuestionModel.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/31/23.
//

import Foundation

struct DBEssentialQuestion: Codable {
  let essentials: [Int]
  
  init(essentials: [Int]) {
    self.essentials = essentials
  }
}
