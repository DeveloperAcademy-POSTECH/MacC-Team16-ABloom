//
//  SignInAppleHelper.swift
//  ABloom
//
//  Created by 정승균 on 10/19/23.
//

import AuthenticationServices
import CryptoKit
import SwiftUI

/// 애플 로그인 성공시 리턴 받을 데이터입니다.
struct SignInWithAppleResult {
  let token: String
  let nonce: String
  let fullName: PersonNameComponents?
}

@MainActor
final class SignInAppleHelper: NSObject {
  
  private var currentNonce: String?
  private var completionHandler: ((Result<SignInWithAppleResult, Error>) -> Void)? = nil
  
  /// 애플 로그인을 제어합니다.
  func startSignInWithAppleFlow() async throws -> SignInWithAppleResult {
    try await withCheckedThrowingContinuation { continuation in
      self.startSignInWithAppleFlow { result in
        switch result {
        case .success(let signInAppleResult):
          continuation.resume(returning: signInAppleResult)
          return
        case .failure(let error):
          continuation.resume(throwing: error)
          return
        }
      }
    }
  }
  
  /// 애플 로그인 시 필요한 기본 플로우입니다.
  private func startSignInWithAppleFlow(completion: @escaping (Result<SignInWithAppleResult, Error>) -> Void) {
    guard let topVC = topViewController() else {
      completion(.failure(URLError(.badURL)))
      return
    }
    let nonce = randomNonceString()
    currentNonce = nonce
    
    completionHandler = completion
    
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email] // 애플 로그인을 통해 제공 받을 부분은 이름입니다.
    request.nonce = sha256(nonce)
    
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = topVC
    authorizationController.performRequests()
  }
  
  /// 랜덤 난수 생성기 -> 로그인 요청시 토큰이 명시적으로 부여되었는지 확인, 재전송 공격 방지
  private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    var randomBytes = [UInt8](repeating: 0, count: length)
    let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
    if errorCode != errSecSuccess {
      fatalError(
        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
      )
    }
    
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    
    let nonce = randomBytes.map { byte in
      // Pick a random character from the set, wrapping around if needed.
      charset[Int(byte) % charset.count]
    }
    
    return String(nonce)
  }
  
  /// sha256으로 해싱하기 위한 메서드입니다.
  @available(iOS 13, *)
  private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
      String(format: "%02x", $0)
    }.joined()
    
    return hashString
  }
}

extension SignInAppleHelper: ASAuthorizationControllerDelegate {
  /// 인증 성공 시 실행되는 메서드입니다.
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    
    guard
      let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
      let nonce = currentNonce,
      let appleIDToken = appleIDCredential.identityToken,
      let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
      completionHandler?(.failure(URLError(.badServerResponse)))
      return
    }
    
    let tokens = SignInWithAppleResult(token: idTokenString, nonce: nonce, fullName: appleIDCredential.fullName)
    
    completionHandler?(.success(tokens))
  }
  
  /// 인증 에러시 에러를 제어하는 메서드입니다.
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
    completionHandler?(.failure(URLError(.cannotFindHost)))
  }
  
}

extension UIViewController: ASAuthorizationControllerPresentationContextProviding {
  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
}

extension SignInAppleHelper {
  
  /// 최상단 뷰 컨트롤러에 애플 로그인 뷰를 보여줄 수 있도록 최상단 뷰 컨트롤러를 찾는 메서드입니다.
  /// SwiftUI는 ViewController를 제공하지 않기 때문에, 임의의 함수를 구현하여 사용합니다.
  /// 다른 로그인 구현시 필요하다면 외부 함수 & 클래스로 빠져야하는 부분입니다.
  func topViewController(controller: UIViewController? = nil) -> UIViewController? {
    
    let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController
    
    if let navigationController = controller as? UINavigationController {
      return topViewController(controller: navigationController.visibleViewController)
    }
    
    if let tabController = controller as? UITabBarController {
      if let selected = tabController.selectedViewController {
        return topViewController(controller: selected)
      }
    }
    
    if let presented = controller?.presentedViewController {
      return topViewController(controller: presented)
    }
    
    return controller
  }
}
