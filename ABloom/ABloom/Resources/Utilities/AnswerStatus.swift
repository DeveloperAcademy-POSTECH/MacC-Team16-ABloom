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
  case moreCommunication
  case moreResearch
  case error
  
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
    case .moreCommunication:
      return "더 대화해보세요"
    case .moreResearch:
      return "더 알아보세요"
    case .error:
      return ""
    }
  }
  
  var textColor: Color {
    switch self {
    case .onlyMe, .reactOnlyMe, .moreResearch, .moreCommunication:
      return .gray600
    case .completed, .onlyFinace, .reactOnlyFinace, .error:
      return .white
    }
  }
  
  var backgroundColor: Color {
    switch self {
    case .completed:
      return .complete
    case .onlyMe, .reactOnlyMe, .moreResearch, .moreCommunication, .error:
      return .white
    case .onlyFinace, .reactOnlyFinace:
      return .purple600
    }
  }
  
  var isStroke: Bool {
    switch self {
    case .onlyMe, .reactOnlyMe, .moreResearch, .moreCommunication:
      return true
    case .completed, .onlyFinace, .reactOnlyFinace, .error:
      return false
    }
  }
}
