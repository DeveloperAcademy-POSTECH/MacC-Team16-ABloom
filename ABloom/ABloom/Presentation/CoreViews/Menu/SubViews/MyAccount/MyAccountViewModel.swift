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
  @Published var showActionSheet: Bool = false
  @Published var showNameChangeAlert: Bool = false
  @Published var nameChangeTextfield: String = ""
  @Published var showDatePicker: Bool = false
  @Published var marriageDate: Date = .now
  @Published var showSignOutCheckAlert: Bool = false
  @Published var isReady = Bool()
  
  func signOut() throws {
    try AuthenticationManager.shared.signOut()
  }
  
  func getMyInfo() async throws {
    let currentUser = try AuthenticationManager.shared.getAuthenticatedUser()
    let user = try await UserManager.shared.getUser(userId: currentUser.uid)
    
    self.userName = user.name
    self.dDay = calculateDDay(estimatedMarriageDate: user.marriageDate ?? .now)
    self.isReady = true
  }
  
  func updateMyName(name: String) throws {
    let myId: String = try AuthenticationManager.shared.getAuthenticatedUser().uid
    try UserManager.shared.updateUserName(userId: myId, name: name)
  }
  
  func updateMyMarriageDate(date: Date) throws {
    let myId: String = try AuthenticationManager.shared.getAuthenticatedUser().uid
    try UserManager.shared.updateMarriageDate(userId: myId, date: date)
  }
  
  private func calculateDDay(estimatedMarriageDate: Date) -> Int {
    let today = Date()
    
    guard let days = Calendar.current.dateComponents([.day], from: today, to: estimatedMarriageDate).day else { return 0 }
    
    return days + 1
  }
}
