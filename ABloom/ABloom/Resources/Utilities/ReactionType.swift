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
    case 1 :
      self = .knowEachOther
    case 2 :
      self = .moreCommunication
    case 3 :
      self = .moreResearch
    default:
      self = .error
    }
  }
}
