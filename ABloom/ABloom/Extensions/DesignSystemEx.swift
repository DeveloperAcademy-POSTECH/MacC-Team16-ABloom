//
//  DesignSystemEx.swift
//  ABloom
//
//  Created by yun on 10/18/23.
//

import SwiftUI

struct DesignSystemEx: View {
  var body: some View {
    VStack {
      // Font Modifier 예제
      Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        .fontWithTracking(fontStyle: .largeTitleBold, value: -0.4)
      
      // Shadow는 fill 함수의 특성상 Shape에만 적용되어, 우선으로 modifier가 적용되어야 함
      Rectangle()
        .clayMorpMDShadow()
        .frame(width: 300, height: 300)
        .foregroundStyle(.biPink)
      
      
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(blueGradient43())
    .ignoresSafeArea(edges: .top)
    
  }
}

#Preview {
  DesignSystemEx()
}
