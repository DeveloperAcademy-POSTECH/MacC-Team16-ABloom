//
//  LoginView.swift
//  ABloom
//
//  Created by 정승균 on 10/19/23.
//

import SwiftUI

struct LoginView: View {
  var body: some View {
    VStack {
      Spacer()
      
      Button {
        
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
