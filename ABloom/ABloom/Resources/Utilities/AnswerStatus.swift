//
//  AnswerStatus.swift
//  ABloom
//
//  Created by Lee Jinhee on 11/8/23.
//

import SwiftUI

enum AnswerStatus {
  case both
  case onlyMe
  case onlyFinace
  case nobody
  case completed
  
  var text: String {
    switch self {
    case .both:
      return "완성해주세요 >"
    case .onlyMe:
      return "답변을 기다리고 있어요"
    case .onlyFinace:
      return "답변해주세요 >"
    case .nobody:
      return ""
    case .completed:
      return " 완성된 문답"
    }
  }
  
  var textColor: Color {
    switch self {
    case .both, .onlyMe, .onlyFinace, .nobody:
      return .stone50
    case .completed:
      return .purple600
    }
  }
  
  var backgroundColor: Color {
    switch self {
    case .onlyMe:
      return .purple500
    case .both, .onlyFinace:
      return .purple600
    case .completed, .nobody:
      return .white
    }
  }

  var image: Image? {
    switch self {
    case .completed:
      return Image(systemName: "checkmark")
    case .both, .onlyMe, .onlyFinace, .nobody:
      return nil
    }
  }
}
