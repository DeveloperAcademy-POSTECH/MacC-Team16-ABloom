//
//  LoginViewModel.swift
//  ABloom
//
//  Created by 정승균 on 10/19/23.
//

import Foundation
import FirebaseAuth

/// Firebase에 저장된 정보를 쉽게 가져올 수 있도록 생성한 구조체입니다.
struct AuthDataResultModel {
  let uid: String
  let name: String?
  
  init(user: User) {
    self.uid = user.uid
    self.name = user.displayName
  }
}

@MainActor
final class LoginViewModel: ObservableObject {
  @Published var user: AuthDataResultModel? = nil
  
  /// Apple ID로 로그인합니다.
  func signInApple() async throws {
    let helper = SignInAppleHelper()
    let tokens = try await helper.startSignInWithAppleFlow()
    let authDataResult = try await signInWithApple(tokens: tokens)
    self.user = authDataResult
    //  let user = DBUser(auth: authDataResult)
    //  try UserManager.shared.createNewUser(user: user)
  }
  
  /// Apple Login Flow를 통해 저장된 토큰 값을 이용해 Credential을 제공받고, 사용자 정보 모델을 리턴합니다.
  ///
  /// - Parameters:
  ///   - tokens: 애플 로그인을 통해 얻은 모델을 전달합니다.
  ///
  /// - Returns:
  ///   - AuthDataResultModel: 유저의 정보를 리턴합니다.
  @discardableResult
  private func signInWithApple(tokens: SignInWithAppleResult) async throws -> AuthDataResultModel {
    let credential = OAuthProvider.appleCredential(withIDToken: tokens.token,
                                                   rawNonce: tokens.nonce,
                                                   fullName: tokens.fullName)
    
    let authDataResult = try await Auth.auth().signIn(with: credential)
    
    return AuthDataResultModel(user: authDataResult.user)
  }
}

