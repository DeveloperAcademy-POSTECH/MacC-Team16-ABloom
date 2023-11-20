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
  
  func getUsers() {
    self.currentUser = UserManager.shared.currentUser
    self.fianceUser = UserManager.shared.fianceUser
  }
}
