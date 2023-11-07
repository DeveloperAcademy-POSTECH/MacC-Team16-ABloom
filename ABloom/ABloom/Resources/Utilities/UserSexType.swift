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
  
  var getBool: Bool {
    self == .man ? true : false
  }
  
  func getGradientImage() -> String {
    switch self {
    case .woman:
      return "avatar_Female circle GradientBG"
    case .man:
      return "avatar_Male circle GradientBG"
    }
  }
}
