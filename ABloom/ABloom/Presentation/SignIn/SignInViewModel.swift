//
//  SignInViewModel.swift
//  ABloom
//
//  Created by 정승균 on 10/19/23.
//

import FirebaseAuth
import Foundation
import KakaoSDKAuth
import KakaoSDKUser

@MainActor
final class SignInViewModel: ObservableObject {
  @Published var user: AuthDataResultModel? = nil
  @Published var isSignInSuccess = false

  @Published var isOldUser = false
  
  @Published var email: String?
  @Published var password: String?
  
  func loadCurrentUser() throws {
    let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
    self.user = authDataResult
    
    if user != nil {
      self.isSignInSuccess = true
    }
  }
  
  /// Apple ID로 로그인합니다.
  func signInApple() async throws {
    let helper = SignInAppleHelper()
    let tokens = try await helper.startSignInWithAppleFlow()
    let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
    self.user = authDataResult
    
    guard let user = self.user else { throw URLError(.badURL)}
    MixpanelManager.setIdentify(id: user.uid)
    await checkOldUser(userId: user.uid, loginType: .apple)

    self.isSignInSuccess = true
  }
  
  func signInGoogle() async throws {
    let helper = SignInGoogleHelper()
    guard let tokens = try await helper.startWithGoogle() else { return }
    let authDataResult = try await AuthenticationManager.shared.signIn(credential: tokens)
    self.user = authDataResult
    
    guard let user = self.user else { throw URLError(.badURL)}
    MixpanelManager.setIdentify(id: user.uid)
    await checkOldUser(userId: user.uid, loginType: .google)
    
    self.isSignInSuccess = true
  }
  
  /// Kakao로 로그인합니다
  func signInKakao() {
    let helper = SignInKakaoHelper()

    if AuthApi.hasToken() { // 발급된 토큰이 있는지 확인
      UserApi.shared.accessTokenInfo { _, error in // 해당 토큰이 유효한지 확인
        if let _ = error { // 에러가 발생했으면 토큰이 유효하지 않음
          print("Invalid ToKen")
          helper.openKakaoService {
            self.email = helper.currentEmail
            self.password = helper.currentId
            self.emailAuthSignUp()
          }
        } else { // 유효한 토큰
          print("Valid Token")
          helper.loadingInfoDidKakaoAuth {
            self.email = helper.currentEmail
            self.password = helper.currentId
            self.emailAuthSignUp()
          }
        }
      }
    } else { // 만료된 토큰
      print("Expired Token")

      helper.openKakaoService {
        self.email = helper.currentEmail
        self.password = helper.currentId
        self.emailAuthSignUp()
      }
    }
  }
  
  private func emailAuthSignUp() {
    guard let email = email, let password = password else { return }
    
    Task {
      do {
        let authDataResultModel = try await AuthenticationManager.shared.emailAuthSignIn(email: email, password: "\(password)")
        self.user = authDataResultModel
        guard let user = self.user else { throw URLError(.badURL)}
        MixpanelManager.setIdentify(id: user.uid)
        await checkOldUser(userId: user.uid, loginType: .kakao)
        self.isSignInSuccess = true

        return
      } catch {
        print("이메일 로그인 실패", error.localizedDescription)
      }
      
      do {
        let _ = try await AuthenticationManager.shared.emailAuthSignUp(email: email, password: "\(password)")
        emailAuthSignUp()
      } catch {
        print("이메일 회원가입 실패", error.localizedDescription)
      }
    }
  }
  
  func checkOldUser(userId: String, loginType: LoginType) async {
    guard let dbUser = try? await UserManager.shared.getUser(userId: userId) else {
      isOldUser = false
      MixpanelManager.signUpSocial(type: loginType.rawValue)
      
      return
    }
    
    MixpanelManager.signIn(type: loginType.rawValue)
    isOldUser = true
  }
}

enum LoginType: String {
  case kakao = "Kakao"
  case apple = "Apple"
  case google = "Google"
}
