//
//  HomeViewModel.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/19/23.
//

import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
  @Published var partnerName: String = "UserName"
  @Published var untilWeddingDate: Int = 0
  @Published var qnaCount: Int = 0
  @Published var isConnected: Bool = false
  @Published var partnerType: UserType = .woman
  @Published var recommendQuestion: String = "추천질문입니다"
  @Published var isConnectButtonTapped = false
  
  func connectButtonTapped() {
    isConnectButtonTapped = true
  }
  
  func setInfo() async throws {
    let dbUser = try await UserManager.shared.getCurrentUser()
    try await getFiance(user: dbUser)
    try getMarrigeDate(user: dbUser)
    self.isConnected = true
  }
  
  private func getFiance(user: DBUser) async throws {
    guard let fiance = user.fiance else { throw URLError(.badServerResponse) }
    
    let fianceUser = try await UserManager.shared.getUser(userId: fiance)
    
    self.partnerName = fianceUser.name ?? ""
  }
  
  private func getMarrigeDate(user: DBUser) throws {
    guard let marrigeDate = user.estimatedMarriageDate else { throw URLError(.badServerResponse) }
    self.untilWeddingDate = calculateDDay(estimatedMarriageDate: marrigeDate)
  }
  
  private func calculateDDay(estimatedMarriageDate: Date) -> Int {
    let today = Date()
    
    guard let days = Calendar.current.dateComponents([.day], from: today, to: estimatedMarriageDate).day else { return 0 }
    
    return days + 1
  }
}
