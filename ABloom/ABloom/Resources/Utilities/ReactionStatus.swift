//
//  ReactionStatus.swift
//  ABloom
//
//  Created by Lee Jinhee on 11/24/23.
//

import Foundation

protocol Reaction {
  var imageName: String { get }
  var reactionContent: String { get }
}

enum ReactionStatus: Reaction, Equatable {
  case noReact(NoReactType)
  case react(ReactionType)
  
  var reactionType: ReactionType? {
    switch self {
    case .react(let reaction):
      return reaction
    case .noReact:
      return nil
    }
  }
  
  var isReacted: Bool {
    switch self {
    case .react(let reaction):
      if reaction == .error {
        return false
      }
      return true
    case .noReact:
      return false
    }
  }
  
  var imageName: String {
    switch self {
    case .react(let reaction):
      reaction.imageName
    case .noReact(let reaction):
      reaction.imageName
    }
  }
  
  var reactionContent: String {
    switch self {
    case .react(let reactionType):
      reactionType.reactionContent
    case .noReact(let noReactType):
      noReactType.reactionContent
    }
  }
}

enum CoupleReactionStatus: Reaction {
  case good
  case communicate
  case research
  case lock
  
  var imageName: String {
    switch self {
    case .good:
      "ResultGood"
    case .communicate:
      "ResultCommunicate"
    case .research:
      "ResultResearch"
    case .lock:
      "Lock"
    }
  }
  
  var reactionContent: String {
    switch self {
    case .good:
      "잘하고 있어요"
    case .communicate:
      "이야기를 나눠보세요"
    case .research:
      "더 자세히 알아보세요"
    case .lock:
      "잠겨있어요"
    }
  }
  
  static func coupleReaction(_ currentUserReactionStatus: ReactionStatus, _ fianceReactionStatus: ReactionStatus) -> CoupleReactionStatus {
    switch (currentUserReactionStatus, fianceReactionStatus) {
      
    case (.react(let currentUserReaction), .react(let fianceReaction)):
      if [currentUserReaction, fianceReaction].contains(.moreCommunication) {
        return .communicate
      } else if [currentUserReaction, fianceReaction].contains(.moreResearch) {
        return .research
      } else {
        return .good
      }
    case (_, _):
      return .lock
    }
  }
}
