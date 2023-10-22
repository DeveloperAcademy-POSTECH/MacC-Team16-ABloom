//
//  LoginViewModel.swift
//  ABloom
//
//  Created by 정승균 on 10/19/23.
//

import Foundation
import FirebaseAuth

@MainActor
final class LoginViewModel: ObservableObject {
  @Published var user: AuthDataResultModel? = nil
  
  func loadCurrentUser() throws {
    let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
    self.user = authDataResult
  }
  
  /// Apple ID로 로그인합니다.
  func signInApple() async throws {
    let helper = SignInAppleHelper()
    let tokens = try await helper.startSignInWithAppleFlow()
    let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
    self.user = authDataResult
    //  let user = DBUser(auth: authDataResult)
    //  try UserManager.shared.createNewUser(user: user)
  }
}

