//
//  Tab.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/17/23.
//

enum TabTitle: String {
  case main = "메인"
  case qna = "문답"
  case info = "내 정보"
}

enum TabImage: String {
  case main = "home"
  case qna = "order"
  case info = "user.alt"
}

enum Tab: CaseIterable {
  case main
  case qna
  case info
  
  var image: String {
    switch self {
    case .main:
      return TabImage.main.rawValue
    case .qna:
      return TabImage.qna.rawValue
    case .info:
      return TabImage.info.rawValue
    }
  }
  
  var title: String {
    switch self {
    case .main:
      return TabTitle.main.rawValue
    case .qna:
      return TabTitle.qna.rawValue
    case .info:
      return TabTitle.info.rawValue
    }
  }
}
