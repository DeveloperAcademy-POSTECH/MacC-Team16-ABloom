//
//  UserSexType.swift
//  ABloom
//
//  Created by 정승균 on 11/6/23.
//

import Foundation

enum UserSexType: String, CaseIterable {
  case woman = "예비신부"
  case man = "예비신랑"
  case none
  
  init(type: Bool) {
    switch type {
    case true:
      self = .man
    case false:
      self = .woman
    }
  }
  
  var getBool: Bool {
    self == .man ? true : false
  }
  
  func getAvatar() -> String {
    switch self {
    case .woman:
      return "FemaleAvatar"
    case .man:
      return "MaleAvatar"
    case .none:
      return ""
    }
  }
}
