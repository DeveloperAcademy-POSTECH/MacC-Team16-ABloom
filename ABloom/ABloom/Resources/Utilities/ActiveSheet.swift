//
//  ActiveSheet.swift
//  ABloom
//
//  Created by Lee Jinhee on 11/21/23.
//

// TODO: 로그인 팝업 창 모듈화하기

import Foundation
import SwiftUI

final class ActiveSheet: ObservableObject {
  enum Kind {
    case signIn
    case signUp
    case none
  }
  
  @Published var kind: Kind = .none {
    didSet { showSheet = kind != .none }
  }
  @Published var showSheet: Bool = false
  
}
