//
//  CustomNavigationBarModifier.swift
//  ABloom
//
//  Created by yun on 10/23/23.
//

import SwiftUI

struct CustomNavigationBarModifier<C, L, R>: ViewModifier where C: View, L: View, R: View {
  
  let centerView: (() -> C)?
  let leftView: (() -> L)?
  let rightView: (() -> R)?
  
  init(centerView: (() -> C)? = nil, leftView: (() -> L)? = nil, rightView: (() -> R)? = nil) {
    self.centerView = centerView
    self.rightView = rightView
    self.leftView = leftView
  }
  
  func body(content: Content) -> some View {
    VStack(spacing: 0) {
      ZStack {
        HStack {
          self.leftView?()
          
          Spacer()
          
          self.rightView?()
        }
        .frame(height: 25)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        
        HStack {
          Spacer()
          
          self.centerView?()
            .customFont(.bodyB)
            .foregroundStyle(.black)
          
          Spacer()
        }
      }
      
      content
    }
    .navigationBarBackButtonHidden(true)
    .ignoresSafeArea(.keyboard)
    
  }
}
