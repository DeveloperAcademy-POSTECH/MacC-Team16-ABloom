//
//  QuestionMainViewModel.swift
//  ABloom
//
//  Created by yun on 10/22/23.
//

import SwiftUI

enum Category: String, CaseIterable {
  case values
  case health
  case finance
  case family
  case couple
  case past
  case lifeStyle
  
  
  var type: String {
    switch self {
    case .values: return "가치관"
    case .health: return "건강"
    case .finance: return "경제"
    case .family: return "가족"
    case .couple: return "부부관계"
    case .past: return "과거"
    case .lifeStyle: return "생활"
    }
  }
  
  
  var imgName: String {
    switch self {
    case .values:
      return "circleIcon_isometic_star"
    case .health:
      return "circleIcon_isometic_health"
    case .finance:
      return "circleIcon_isometic_money"
    case .family:
      return "circleIcon_isometic_sofa"
    case .couple:
      return "circleIcon_isometic_bed"
    case .past:
      return "circleIcon_isometic_reversed_timer"
    case .lifeStyle:
      return "circleIcon_isometic_rice"
    }
  }
}

class QuestionMainViewModel: ObservableObject {

}
