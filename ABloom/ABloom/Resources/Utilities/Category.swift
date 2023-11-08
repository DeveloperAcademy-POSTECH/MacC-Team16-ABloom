//
//  Category.swift
//  ABloom
//
//  Created by Lee Jinhee on 11/7/23.
//

enum Category: String, CaseIterable {
  case communication
  case values
  case finance
  case lifestyle
  case child
  case family
  case sex
  case health
  case wedding
  case future
  case present
  case past
  
  var type: String {
    switch self {
    case .communication: return "소통"
    case .values: return "가치관"
    case .finance: return "경제"
    case .lifestyle: return "생활"
    case .child: return "자녀"
    case .family: return "가족"
    case .sex: return "부부 관계"
    case .health: return "건강"
    case .wedding: return "결혼 준비"
    case .future: return "미래"
    case .present: return "현재"
    case .past: return "과거"
    }
  }
  
  var imgName: String {
    switch self {
    case .communication:
      return "circleIcon_isometric_chatting"
    case .values:
      return "circleIcon_isometic_star"
    case .finance:
      return "circleIcon_isometic_money"
    case .lifestyle:
      return "circleIcon_isometic_rice"
    case .child:
      return "circleIcon_isometic_dummy"
    case .family:
      return "circleIcon_isometic_sofa"
    case .sex:
      return "circleIcon_isometic_bed"
    case .health:
      return "circleIcon_isometic_health"
    case .wedding:
      return "circleIcon_isometic_love_calender"
    case .future:
      return "circleIcon_isometic_target"
    case .present:
      return "circleIcon_isometric_location"
    case .past:
      return "circleIcon_isometic_reversed_timer"
    }
  }
}
