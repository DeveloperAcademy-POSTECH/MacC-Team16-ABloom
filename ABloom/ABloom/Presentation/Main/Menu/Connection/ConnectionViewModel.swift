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
        try await ConnectionManager.shared.connectFiance(connectionCode: self.inputText)
        try? await UserManager.shared.fetchCurrentUser()
        try? await UserManager.shared.fetchFianceUser()
        getUsers()
      } catch let error as ConnectionError {
        self.errorMessage = error.errorMessage()
        self.showErrorAlert = true
      }
    }
  }
}
