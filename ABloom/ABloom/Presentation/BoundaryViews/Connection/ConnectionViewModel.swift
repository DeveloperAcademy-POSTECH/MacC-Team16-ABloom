//
//  ConnectionViewModel.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/25/23.
//

import SwiftUI

final class ConnectionViewModel: ObservableObject {

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
  func tryConnect() {
    self.isConnectAble = isTargetCodeInputVaild && codeInputText.count == 3
    if !isConnectAble {
      self.showAlert = true
    }
  }
  
  func getMyCode() async throws {
    let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
    self.myCode = try await UserManager.shared.getUser(userId: userId).invitationCode
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
