//
//  GradientColors.swift
//  ABloom
//
//  Created by yun on 10/17/23.
//

import SwiftUI

extension View{
  
  /***
   Customized GradientColors
   - 뷰의 형태를 지님
   
   총 4개의 함수 존재
   1. blueGradient54()
   2. blueGradient40()
   3. pinkGradient54()
   4. pinkGradient40()
   
   사용예제
   -
   .background(blueGradient54())
   */
  /// Blue500 - Blue400 Gradient
  public func blueGradient54() -> some View {
    LinearGradient(colors: [.blue500, .blue400], startPoint: .bottomLeading, endPoint: .topTrailing)
  }
  /// Blue400 - Blue300 Gradient
  public func blueGradient43() -> some View {
    LinearGradient(colors: [.blue400, .biBlue], startPoint: .bottomLeading, endPoint: .topTrailing)
  }
  /// Plue500 - Plue400 Gradient
  public func pinkGradient54() -> some View {
    LinearGradient(colors: [.pink500, .pink400], startPoint: .bottomLeading, endPoint: .topTrailing)
  }
  /// Plue400 - Plue300 Gradient
  public func pinkGradient43() -> some View {
    LinearGradient(colors: [.pink400, .biPink], startPoint: .bottomLeading, endPoint: .topTrailing)
  }
}
