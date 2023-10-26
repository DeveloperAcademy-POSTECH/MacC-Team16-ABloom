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
    VStack(spacing: 12) {
      Spacer().frame(maxHeight: 90)
      
      titleArea
      
      Spacer().frame(maxHeight: 30)

      chatBubbleArea
      
      Spacer()
      
      buttonArea
      
      bottomArea
    }
    .padding(.horizontal, 20)
    .background(
      backgroundDefault()
    )
    
    /// Login Task
    .task {
      try? loginVM.loadCurrentUser()
    }
    .navigationDestination(isPresented: $loginVM.isSignInSuccess) {
      RegistrationView(showLoginView: $showLoginView)
    }
  }
}

#Preview {
  NavigationStack {
    LoginView(showLoginView: .constant(true))
  }
}

extension LoginView {
  private var titleArea: some View {
    HStack {
      VStack(alignment: .leading, spacing: 11) {
        Text("예비부부가 함께 써내려가는\n둘 만의 결혼문답")
          .fontWithTracking(.title2Bold, tracking: -0.4)
          .foregroundStyle(.stone600)
          .frame(minHeight: 72)
        Text("MERY")
          .fontWithTracking(.largeTitleBold)
          .foregroundStyle(.stone950)
      }
      .multilineTextAlignment(.leading)
      
      Spacer()
    }
  }
  
  private var chatBubbleArea: some View {
    VStack(spacing: 0) {
      
      chatBubbleBlue
      
      chatBubblePink
      
      ForEach(0..<3) { _ in
        Circle()
          .frame(width: 8, height: 8)
          .foregroundStyle(.stone300)
          .padding(.vertical, 6)
      }
      
    }
  }
  
  private var chatBubbleBlue: some View {
    HStack {
      RoundedRectangle(cornerRadius: 12)
        .loginChatBubbleShadow()
        .foregroundStyle(.blue100)
        .frame(width: 260, height: 50)
        .overlay(alignment: .leading) {
          Text("돈관리는 어떻게 하는 게 좋을까?")
            .foregroundStyle(.stone800)
            .font(.custom("SpoqaHanSansNeo-Medium", size: 14))
            .tracking(-0.4)
            .padding(.leading, 50)
        }
        .offset(x: -44)
      
      Spacer()
    }
    .padding(.bottom, 22)
  }
  
  private var chatBubblePink: some View {
    HStack {
      Spacer()
      
      RoundedRectangle(cornerRadius: 12)
        .loginChatBubbleShadow()
        .frame(width: 310, height: 74)
        .foregroundStyle(.pink100)
        .overlay(alignment: .leading) {
          Text("부모님들이 건강이 안 좋아지시거나 해서\n누군가 모셔야 한다면 어떻게 할까?")
            .foregroundStyle(.stone800)
            .font(.custom("SpoqaHanSansNeo-Medium", size: 14))
            .tracking(-0.4)
            .lineSpacing(2)
            .padding(.leading, 20)
        }
        .offset(x: 44)
        .padding(.bottom, 26)
    }
  }
  
  private var buttonArea: some View {
    Button {
      Task {
        try await loginVM.signInApple()
      }
    } label: {
      SignInWithAppleButtonViewRepresentable(type: .continue, style: .black)
        .allowsHitTesting(false)
    }
    .frame(height: 56)
    .padding(.bottom, 10)
  }
  
  private var bottomArea: some View {
    VStack(spacing: 12) {
      VStack(spacing: 0) {
        Text("로그인하시면 만 14세 이상이고,")
        Text("아래 내용에 동의하는 것으로 간주됩니다.")
      }
      .fontWithTracking(.footnoteR, tracking: -0.4)
      .foregroundStyle(.stone800)
      .multilineTextAlignment(.center)
      
      HStack(spacing: 24) {
        Button(action: {
          loginVM.privacyPolicyTapped()
        }, label: {
          Text("개인정보처리방침").underline()
        })
        Button(action: {
          loginVM.termsOfUseTapped()
        }, label: {
          Text("이용약관").underline()
        })
      }
      .fontWithTracking(.caption1R, tracking: -0.4)
      .foregroundStyle(.stone600)
      .padding(.bottom, 36)
    }
    .sheet(isPresented: $loginVM.showPrivacyPolicy) {
      WebView(urlString: ServiceWebURL.privacyPolicy.rawValue)
    }
    .sheet(isPresented: $loginVM.showTermsOfUse) {
      WebView(urlString: ServiceWebURL.termsOfuse.rawValue)
    }
  }
}
