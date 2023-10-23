//
//  AppleLoginButtonViewRepresentable.swift
//  ABloom
//
//  Created by 정승균 on 10/19/23.
//

import SwiftUI
import AuthenticationServices

/// 애플에 내장된 로그인 버튼을 구현할 수 있는 UIViewRepresentable입니다.
///
/// - Parameters:
///     - type: 버튼의 안내 메세지를 설정합니다.
///     - style: 버튼의 스타일을 설정합니다.
/// - Returns: Apple 로그인 버튼을 표시합니다.
///
/// ```swift
/// // 버튼 생성 예시
/// SignInWithAppleButtonViewRepresentable(type: .continue, style: .black)
/// ```
struct SignInWithAppleButtonViewRepresentable: UIViewRepresentable {
  
  let type: ASAuthorizationAppleIDButton.ButtonType
  let style: ASAuthorizationAppleIDButton.Style
  
  func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
    return ASAuthorizationAppleIDButton(type: type, style: style)
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    
  }
  
}
