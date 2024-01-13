//
//  SignInView.swift
//  ABloom
//
//  Created by 정승균 on 11/15/23.
//

import SwiftUI

struct SignInView: View {
  @StateObject var signInVM = SignInViewModel()
  @Environment(\.dismiss) private var dismiss
  
  @ObservedObject var activeSheet: ActiveSheet
  
  var body: some View {
    
    VStack(alignment: .leading, spacing: 14) {
      Text("로그인")
        .customFont(.title1B)
      Text("간편하게 로그인해서 메리를 시작해보세요.")
        .customFont(.caption1B)
        .foregroundStyle(.gray500)
        .padding(.bottom, 10)
      
      buttonArea
    }
    .padding(.vertical, 36)
    .padding(.horizontal, 20)
    
    .task {
      try? signInVM.loadCurrentUser()
    }
    
    .onChange(of: signInVM.isSignInSuccess) { newValue in
      if signInVM.isOldUser {
        dismiss()
      } else {
        dismiss()
        activeSheet.kind = .signUp
      }
    }
  }
}

#Preview {
  SignInView(activeSheet: ActiveSheet())
}

extension SignInView {
  private var buttonArea: some View {
    VStack(spacing: 12) {
      Button {
        signInVM.signInKakao()
      } label: {
        HStack(spacing: 8) {
          Image("KakaoLoginLogo")
            .resizable()
            .frame(width: 20, height: 20)
          Text("카카오 로그인")
            .font(.system(size: 20))
            .foregroundStyle(.black.opacity(0.85))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 52)
        .background(.kakaoYellow)
        .cornerRadius(8, corners: .allCorners)
      }
      
      Button {
        Task { try await signInVM.signInApple() }
      } label: {
        SignInWithAppleButtonViewRepresentable(type: .signIn, style: .black)
          .allowsHitTesting(false)
      }
      .frame(height: 52)
      
      Button {
        Task { try await signInVM.signInGoogle() }
      } label: {
        Text("구글 로그인")
          .font(.system(size: 20))
          .foregroundStyle(.black.opacity(0.85))
          .frame(maxWidth: .infinity)
          .frame(height: 52)
          .background(.white)
          .cornerRadius(8, corners: .allCorners)
      }
    }
  }
}
