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

enum TabIcon: String {
  case main = "house.fill"
  case qna = "doc.plaintext.fill"
  case info = "person.fill"
}

enum Tab: CaseIterable {
  case main
  case qna
  case info
  
  var icon: String {
    switch self {
    case .main:
      return TabIcon.main.rawValue
    case .qna:
      return TabIcon.qna.rawValue
    case .info:
      return TabIcon.info.rawValue
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
