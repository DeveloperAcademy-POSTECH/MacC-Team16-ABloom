//
//  AnswerStatus.swift
//  ABloom
//
//  Created by Lee Jinhee on 11/8/23.
//

import SwiftUI

enum AnswerStatus {
  case onlyMe
  case onlyFinace
  case reactOnlyMe
  case reactOnlyFinace
  case completed
  
  var text: String {
    switch self {
    case .onlyMe:
      return "답변을 기다리고 있어요"
    case .onlyFinace:
      return "답변해주세요  >"
    case .reactOnlyMe:
      return "반응을 기다리고 있어요"
    case .reactOnlyFinace:
      return "반응해주세요  >"
    case .completed:
      return "완성된 문답"
    }
  }
  
  var textColor: Color {
    switch self {
    case .onlyMe, .reactOnlyMe:
      return .gray600
    case .completed, .onlyFinace, .reactOnlyFinace:
      return .white
    }
  }
  
  var backgroundColor: Color {
    switch self {
    case .completed:
      return .complete
    case .onlyMe, .reactOnlyMe:
      return .white
    case .onlyFinace, .reactOnlyFinace:
      return .purple600
    }
  }
}
