//
//  ReactionType.swift
//  ABloom
//
//  Created by 정승균 on 11/8/23.
//

import Foundation

enum ReactionType: Int {
  case good = 0
  case knowEachOther
  case moreCommunication
  case moreResearch
  case error
  
  init?(rawValue: Int) {
    switch rawValue {
    case 0:
      self = .good
    case 1:
      self = .knowEachOther
    case 2:
      self = .moreCommunication
    case 3:
      self = .moreResearch
    default:
      self = .error
    }
  }
  
  var reactionContent: String {
    switch self {
    case .good:
      return "💙 좋았어요"
    case .knowEachOther:
      return "🤝 서로에 대해 더 알게 됐어요"
    case .moreCommunication:
      return "💬 더 대화해볼래요"
    case .moreResearch:
      return "💡 더 찾아봐야겠어요"
    case .error:
      return "error"
    }
  }
  
  func isPositiveReact() -> Bool {
    switch self {
    case .good, .knowEachOther:
      return true
    case .moreCommunication, .moreResearch, .error:
      return false
    }
  }
}
