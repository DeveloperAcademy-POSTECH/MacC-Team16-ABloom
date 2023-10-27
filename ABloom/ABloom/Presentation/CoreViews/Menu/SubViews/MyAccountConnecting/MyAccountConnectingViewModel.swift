//
//  MyAccountConnectingViewModel.swift
//  ABloom
//
//  Created by 정승균 on 10/22/23.
//

import SwiftUI

@MainActor
final class MyAccountConnectingViewModel: ObservableObject {
  @Published var codeInputText: String = ""
  @Published var myCode: String?
  @Published var isConnectAble: Bool = false
  @Published var showToast = false
  @Published var showAlert = false
  
  // TODO: 연결시도가능, 유효가능 구분
  var isTargetCodeInputVaild: Bool {
    !codeInputText.isEmpty
  }
  
  // TODO: 연결 가능 확인 로직 수정
  func tryConnect() async throws {
    self.isConnectAble = isTargetCodeInputVaild && codeInputText.count == 10
    if !isConnectAble {
      self.showAlert = true
    } else {
      try await connect()
    }
  }
  
  func getMyCode() async throws {
    let currentUser = try AuthenticationManager.shared.getAuthenticatedUser()
    print("현재 유저 -> \(currentUser)")
    self.myCode = try await UserManager.shared.getUser(userId: currentUser.uid).invitationCode
  }
  
  func connect() async throws {
    try await UserManager.shared.connectFiance(connectionCode: codeInputText)
  }
  
  func copyClipboard() {
    UIPasteboard.general.string = myCode
    withAnimation {
      showToast.toggle()
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      withAnimation {
        self.showToast = false
      }
    }
  }
}
