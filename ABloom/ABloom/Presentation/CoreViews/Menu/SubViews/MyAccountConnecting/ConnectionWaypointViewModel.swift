//
//  ConnectionWaypointViewModel.swift
//  ABloom
//
//  Created by 정승균 on 10/27/23.
//

import Foundation

@MainActor
final class ConnectionWaypointViewModel: ObservableObject {
  @Published var currentUser: DBUser?
  
  func getUser() async throws {
    let currentUser = try AuthenticationManager.shared.getAuthenticatedUser()
    
    self.currentUser = try await UserManager.shared.getUser(userId: currentUser.uid)
  }
  
}
