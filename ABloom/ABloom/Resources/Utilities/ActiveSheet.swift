//
//  ActiveSheet.swift
//  ABloom
//
//  Created by Lee Jinhee on 11/21/23.
//

import Foundation

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
