//
//  ConnectionViewModel.swift
//  ABloom
//
//  Created by 정승균 on 11/22/23.
//

import Foundation

@MainActor
final class ConnectionViewModel: ObservableObject {
  @Published var currentUser: DBUser?
  @Published var fianceUser: DBUser?
  
  @Published var inputText: String = ""
  @Published var showErrorAlert = false
  
  var isTargetCodeInputVaild: Bool {
    !inputText.isEmpty && currentUser != nil
  }
  
  var errorMessage: String = ""
  
  init() {
    getUsers()
  }
  
  func getUsers() {
    self.currentUser = UserManager.shared.currentUser
    self.fianceUser = UserManager.shared.fianceUser
  }
  
  func connectUser() {
    Task {
      do {
        try await UserManager.shared.connectFiance(connectionCode: self.inputText)
        MixpanelManager.connectComplete(code: self.inputText)
        getUsers()
      } catch let error as ConnectionError {
        self.errorMessage = error.errorMessage()
        self.showErrorAlert = true
      }
    }
  }
}
