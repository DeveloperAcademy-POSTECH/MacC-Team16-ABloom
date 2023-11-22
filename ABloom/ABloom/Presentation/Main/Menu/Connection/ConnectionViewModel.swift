//
//  ConnectionViewModel.swift
//  ABloom
//
//  Created by 정승균 on 11/22/23.
//

import Foundation

final class ConnectionViewModel: ObservableObject {
  @Published var currentUser: DBUser?
  @Published var fianceUser: DBUser?
  
  @Published var inputText: String = ""
  
  var isTargetCodeInputVaild: Bool {
    !inputText.isEmpty
  }
  
  init() {
    getUsers()
  }
  
  func getUsers() {
    currentUser = UserManager.shared.currentUser
    fianceUser = UserManager.shared.fianceUser
  }
}
