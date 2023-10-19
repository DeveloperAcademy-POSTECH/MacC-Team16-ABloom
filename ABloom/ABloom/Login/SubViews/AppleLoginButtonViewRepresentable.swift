//
//  AppleLoginButtonViewRepresentable.swift
//  ABloom
//
//  Created by 정승균 on 10/19/23.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleButtonViewRepresentable: UIViewRepresentable {
  
  let type: ASAuthorizationAppleIDButton.ButtonType
  let style: ASAuthorizationAppleIDButton.Style
  
  func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
    return ASAuthorizationAppleIDButton(type: type, style: style)
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    
  }
  
}
