//
//  GradientColors.swift
//  ABloom
//
//  Created by yun on 10/17/23.
//

import SwiftUI

extension View{
  public func blueGradient54() -> some View {
    LinearGradient(colors: [.blue500, .blue400], startPoint: .bottomLeading, endPoint: .topTrailing)
  }
  public func blueGradient40() -> some View {
    LinearGradient(colors: [.blue400, .biBlue], startPoint: .bottomLeading, endPoint: .topTrailing)
  }
  public func pinkGradient54() -> some View {
    LinearGradient(colors: [.pink500, .pink400], startPoint: .bottomLeading, endPoint: .topTrailing)
  }
  public func pinkGradient40() -> some View {
    LinearGradient(colors: [.pink400, .biPink], startPoint: .bottomLeading, endPoint: .topTrailing)
  }
}
