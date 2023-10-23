//
//  MyAccountViewModel.swift
//  ABloom
//
//  Created by 정승균 on 10/22/23.
//

import Foundation

@MainActor
final class MyAccountViewModel: ObservableObject {
  @Published var userName: String?
  @Published var dDay: Int?
  
  func signOut() throws {
    try AuthenticationManager.shared.signOut()
  }
  
  func getMyInfo() async throws {
    let currentUser = try AuthenticationManager.shared.getAuthenticatedUser()
    let user = try await UserManager.shared.getUser(userId: currentUser.uid)
    
    self.userName = user.name
    self.dDay = calculateDDay(estimatedMarriageDate: user.estimatedMarriageDate ?? .now)
  }
  
  private func calculateDDay(estimatedMarriageDate: Date) -> Int {
    let today = Date()
    
    guard let days = Calendar.current.dateComponents([.day], from: today, to: estimatedMarriageDate).day else { return 0 }
    
    return days + 1
  }
}