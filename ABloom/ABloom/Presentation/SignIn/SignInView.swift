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
        .customFont(.caption1R)
        .foregroundStyle(.gray500)
        .padding(.bottom, 14)
      
      buttonArea
    }
    .padding(.top, 28)
    .padding(.bottom, 34)
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
            .scaledToFit()
            .frame(width: 18)
          
          Text("카카오 로그인")
            .customFont(.calloutB)
            .foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(.kakaoYellow)
        .cornerRadius(12, corners: .allCorners)
      }
      
      Button {
        Task { try await signInVM.signInApple() }
      } label: {
        HStack(spacing: 8) {
          Image("AppleLoginLogo")

          Text("Apple로 로그인")
            .customFont(.calloutB)
            .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(.black)
        .cornerRadius(12, corners: .allCorners)
      }
      
      Button {
        Task { try await signInVM.signInGoogle() }
      } label: {
        HStack(spacing: 8) {
          Image("GoogleLoginLogo")
            .resizable()
            .frame(width: 16, height: 16)
          Text("Google로 로그인")
            .customFont(.calloutB)
            .foregroundStyle(.black.opacity(0.85))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(
          RoundedRectangle(cornerRadius: 12)
            .stroke(lineWidth: 1)
            .foregroundStyle(.googleGray)
            .background(.white)
        )
      }
    }
  }
}
