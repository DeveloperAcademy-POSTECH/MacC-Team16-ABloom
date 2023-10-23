//
//  AuthenticationManager.swift
//  ABloom
//
//  Created by 정승균 on 10/22/23.
//

import FirebaseAuth
import Foundation

/// Firebase에 저장된 정보를 쉽게 가져올 수 있도록 생성한 구조체입니다.
struct AuthDataResultModel {
  let uid: String
  let name: String?
  
  init(user: User) {
    self.uid = user.uid
    self.name = user.displayName
  }
}

/// 유저 인증관련 메서드를 실행하는 클래스입니다.
final class AuthenticationManager {
  static let shared = AuthenticationManager()
  private init() { }
  
  /// Apple Login Flow를 통해 저장된 토큰 값을 이용해 Credential을 제공받고, 사용자 정보 모델을 리턴합니다.
  ///
  /// - Parameters:
  ///   - tokens: 애플 로그인을 통해 얻은 모델을 전달합니다.
  ///
  /// - Returns:
  ///   - AuthDataResultModel: 유저의 정보를 리턴합니다.
  @discardableResult
  func signInWithApple(tokens: SignInWithAppleResult) async throws -> AuthDataResultModel {
    let credential = OAuthProvider.appleCredential(withIDToken: tokens.token, rawNonce: tokens.nonce, fullName: tokens.fullName)
    
    return try await signIn(credential: credential)
  }
  
  func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
    let authDataResult = try await Auth.auth().signIn(with: credential)
    
    return AuthDataResultModel(user: authDataResult.user)
  }
  
  /// 이미 로그인 상태인 유저 정보를 가져오는 메서드입니다.
  ///
  /// - Returns:
  ///   - AuthDataResultModel: 파이어베이스에 저장된 유저에대한 기초적인 정보를 가지고 있는 모델입니다.
  func getAuthenticatedUser() throws -> AuthDataResultModel {
    guard let user = Auth.auth().currentUser else {
      throw URLError(.badServerResponse)
    }
    
    return AuthDataResultModel(user: user)
  }
  
  /// 로컬 Firebase에 저장된 유저 정보를 삭제하고 로그아웃 합니다.
  func signOut() throws {
    try Auth.auth().signOut()
  }
}
