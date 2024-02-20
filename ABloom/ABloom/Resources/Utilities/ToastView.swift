//
//  ToastView.swift
//  ABloom
//
//  Created by 정승균 on 12/12/23.
//

import SwiftUI

struct ToastView: View {
  let message: String
  
  var body: some View {
    ZStack {
      Capsule()
        .frame(height: 50)
        .foregroundStyle(Color.init(hex: 0x000000, opacity: 0.7))
      
      Text(message)
        .fontWithTracking(.calloutR)
        .foregroundColor(.white)
    }
    .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
    .zIndex(1)  // Ensure the toast appears on top
  }
}

#Preview {
  VStack {
    ToastView(message: "토스트임")
  }
  .padding(.horizontal, 10)
}
