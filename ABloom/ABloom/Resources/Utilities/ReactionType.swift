//
//  ReactionType.swift
//  ABloom
//
//  Created by 정승균 on 11/8/23.
//

import Foundation

enum ReactionType: Int, Reaction {
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
  
  var imageName: String {
    switch self {
    case .good:
      "ReactionLike"
    case .knowEachOther:
      "ReactionKnow"
    case .moreCommunication:
      "ReactionCommunicate"
    case .moreResearch:
      "ReactionResearch"
    case .error:
      ""
    }
  }
  
  var reactionContent: String {
    switch self {
    case .good:
      return "좋아요"
    case .knowEachOther:
      return "잘 알게 됐어요"
    case .moreCommunication:
      return "대화해봐요"
    case .moreResearch:
      return "더 찾아봐요"
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

enum NoReactType: Reaction {
  case lock
  case plus
  case wait
  
  var imageName: String {
    switch self {
    case .lock:
      "Lock"
    case .plus:
      "Plus"
    case .wait:
      "Wait"
    }
  }
  
  var reactionContent: String {
    switch self {
    case .lock:
      "잠겨있어요"
    case .plus:
      ""
    case .wait:
      "기다리고 있어요"
    }
  }
}
