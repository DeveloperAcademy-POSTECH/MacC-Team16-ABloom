//
//  ProfileMenuViewModel.swift
//  ABloom
//
//  Created by 정승균 on 11/20/23.
//

import Foundation

final class ProfileMenuViewModel: ObservableObject {
  @Published var currentUser: DBUser?
  @Published var fianceUser: DBUser?
  @Published var marriageStatus: MarriageStatus?
  
  init() {
    updateDayStatus()
  }
  
  func getUsers() {
    self.currentUser = UserManager.shared.currentUser
    self.fianceUser = UserManager.shared.fianceUser
  }
  
  func signOut() throws {
    try AuthenticationManager.shared.signOut()
  }
  
  private func updateDayStatus() {
    guard let marriageDate = currentUser?.marriageDate else { return }
    
    let dDay = Date().calculateDDay(with: marriageDate)
    
    if dDay <= 0 {
      marriageStatus = .married(-dDay + 1)
    } else if dDay == 0 {
      marriageStatus = .dday
    } else {
      marriageStatus = .notMarried(dDay)
    }
  }
}
