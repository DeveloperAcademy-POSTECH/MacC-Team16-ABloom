//
//  LoginViewModel.swift
//  ABloom
//
//  Created by 정승균 on 10/19/23.
//

import FirebaseAuth
import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
  @Published var user: AuthDataResultModel? = nil
  @Published var isSignInSuccess = false
  @Published var showPrivacyPolicy = false
  @Published var showTermsOfUse = false
  @Published var isOldUser = false
  
  func privacyPolicyTapped() {
    showPrivacyPolicy = true
  }
  
  func termsOfUseTapped() {
    showTermsOfUse = true
  }
  
  func loadCurrentUser() throws {
    let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
    self.user = authDataResult
    self.isSignInSuccess = true
  }
  
  /// Apple ID로 로그인합니다.
  func signInApple() async throws {
    // 유저 로그인
    let helper = SignInAppleHelper()
    let tokens = try await helper.startSignInWithAppleFlow()
    let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
    self.user = authDataResult
    
    guard let user = self.user else { throw URLError(.badURL)}
    
    await checkOldUser(userId: user.uid)
    
    self.isSignInSuccess = true
  }
  
  func checkOldUser(userId: String) async {
    guard let dbUser = try? await UserManager.shared.getUser(userId: userId) else {
      return
    }
    
    isOldUser = true
  }
}
