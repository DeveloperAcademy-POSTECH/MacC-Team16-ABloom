//
//  ToastView.swift
//  ABloom
//
//  Created by 정승균 on 10/22/23.
//

import SwiftUI

struct ToastView: View {
  let message: String
  
  var body: some View {
    Text(message)
      .fontWithTracking(fontStyle: .footnoteR)
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .background(.stone400)
      .foregroundColor(.white)
      .cornerRadius(12)
      .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
      .zIndex(1)  // Ensure the toast appears on top
  }
}

#Preview {
  ToastView(message: "토스트임")
}
