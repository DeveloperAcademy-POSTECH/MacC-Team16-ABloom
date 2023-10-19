//
//  LoginView.swift
//  ABloom
//
//  Created by 정승균 on 10/19/23.
//

import SwiftUI

struct LoginView: View {
  @StateObject var loginVM = LoginViewModel()
  
  var body: some View {
    VStack {
      Spacer()
      
      if let user = loginVM.user {
          Text("User Id \(user.uid)")
        if let name = user.name {
          Text("User Name \(name)")
        }
      }
      
      Button {
        Task {
          try await loginVM.signInApple()
        }
      } label: {
        SignInWithAppleButtonViewRepresentable(type: .continue, style: .black)
          .allowsHitTesting(false)
      }
      .frame(height: 56)
      .padding(.horizontal, 20)
      .padding(.bottom, 60)
    }
  }
}

#Preview {
  LoginView()
}
