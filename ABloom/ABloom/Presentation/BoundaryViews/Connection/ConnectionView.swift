//
//  ConnectionView.swift
//  ABloom
//
//  Created by 정승균 on 10/22/23.
//

import SwiftUI

@MainActor
final class ConnectionViewModel: ObservableObject {
  @Published var invitationCode: String?
  
  func getInvitationCode() async throws {
    let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
    self.invitationCode = try await UserManager.shared.getUser(userId: userId).invitationCode
    
  }
}

struct ConnectionView: View {
  @StateObject var connectionVM = ConnectionViewModel()
  var body: some View {
    VStack {
      Text("나의 연결 코드")
      if let invitationCode = connectionVM.invitationCode {
        Text("\(invitationCode)")
      }
    }
    .task {
      try? await connectionVM.getInvitationCode()
    }
  }
}

#Preview {
  ConnectionView()
}
