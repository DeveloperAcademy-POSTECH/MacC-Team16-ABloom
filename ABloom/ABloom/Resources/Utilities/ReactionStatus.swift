//
//  ReactionStatus.swift
//  ABloom
//
//  Created by Lee Jinhee on 11/24/23.
//

import Foundation

enum ReactionStatus: Equatable {
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
  
  var reactionImgName: String {
    switch self {
    case .react(let reaction):
      reaction.imageName
    case .noReact(let reaction):
      reaction.imageName
    }
  }
}
