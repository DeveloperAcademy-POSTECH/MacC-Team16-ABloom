//
//  NavigationModel.swift
//  ABloom
//
//  Created by yun on 10/31/23.
//

import Foundation

@MainActor
final class NavigationModel: ObservableObject {
  // 기본 false 반환
  @Published var isPopToMain = Bool()
  
  static let shared = NavigationModel()
  
  func popToMainToggle() {
    self.isPopToMain.toggle()
  }
}
