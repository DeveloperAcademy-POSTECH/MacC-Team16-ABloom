//
//  LoginView.swift
//  ABloom
//
//  Created by 정승균 on 10/19/23.
//

import SwiftUI

struct LoginView: View {
  @StateObject var loginVM = LoginViewModel()
  @Binding var showLoginView: Bool
  
  var body: some View {
    VStack {
      Spacer()
      
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
    .task {
      try? loginVM.loadCurrentUser()
    }
    .navigationDestination(isPresented: $loginVM.isSignInSuccess) {
      RegistrationView(showLoginView: $showLoginView)
    }
    .background(backgroundDefault())
  }
}

#Preview {
  NavigationStack {
    LoginView(showLoginView: .constant(true))
  }
}
