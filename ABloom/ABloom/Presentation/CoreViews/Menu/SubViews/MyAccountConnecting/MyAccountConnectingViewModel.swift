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
  @Published var errorMessage = ""
  @Published var isConnected = Bool()

  /// 연결시도가능, 유효가능 구분
  var isTargetCodeInputVaild: Bool {
    !codeInputText.isEmpty
  }
  
  func getMyCode() async throws {
    let currentUser = try AuthenticationManager.shared.getAuthenticatedUser()
    print("현재 유저 -> \(currentUser)")
    self.myCode = try await UserManager.shared.getUser(userId: currentUser.uid).invitationCode
  }
  
  func tryConnect() async throws {
    self.isConnectAble = isTargetCodeInputVaild && codeInputText.count == 10
    self.isConnected = true
    if isConnectAble {
      try await connect()
    } else {
      self.errorMessage = "상대방의 코드를 올바르게 입력했는지 확인해주세요."
      self.showAlert = true
    }
  }
  
  private func connect() async throws {
    do {
      try await ConnectionManager.shared.connectFiance(connectionCode: codeInputText)
    } catch {
      switch error {
      case let connectionError as ConnectionError:
        self.errorMessage = connectionError.errorMessage()
        self.showAlert = true
      default:
        self.errorMessage = error.localizedDescription
        self.showAlert = true
      }
    }
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
