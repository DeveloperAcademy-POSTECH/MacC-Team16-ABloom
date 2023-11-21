//
//  SplashView.swift
//  ABloom
//
//  Created by yun on 11/21/23.
//

import FLAnimatedImage
import SwiftUI

struct SplashView: View {
  var body: some View {
    
    GIFView(type: .name("example"))
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .ignoresSafeArea()
      
  }
}

#Preview {
  SplashView()
}
