//
//  MyAccountConnectingViewModel.swift
//  ABloom
//
//  Created by 정승균 on 10/22/23.
//

import Foundation

@MainActor
final class MyAccountConnectingViewModel: ObservableObject {
  @Published var codeInputText: String = ""
  @Published var myCode: String?
  @Published var showToast = false
  
  var isTargetCodeVaild: Bool {
    !codeInputText.isEmpty
  }
  
  func getMyCode() async throws {
    let currentUser = try AuthenticationManager.shared.getAuthenticatedUser()
    print("현재 유저 -> \(currentUser)")
    self.myCode = try await UserManager.shared.getUser(userId: currentUser.uid).invitationCode
  }
  
  func connect() async throws {
    try await UserManager.shared.connectFiance(connectionCode: codeInputText)
  }
}
