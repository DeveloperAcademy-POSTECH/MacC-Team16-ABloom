//
//  GradientColors.swift
//  ABloom
//
//  Created by yun on 10/17/23.
//

import SwiftUI


extension Shape {
  
  public func clayMorpMDShadow() -> some View {
    self.fill(
      .shadow(.inner(color: Color.black.opacity(0.37), radius: 10, x: 0, y: -3))
      .shadow(.inner(color: Color.white.opacity(0.5), radius: 15, x: 3, y: 1))
      .shadow(.drop(color: Color.black.opacity(0.03), radius: 20, x: 0, y: 7))
    )
  }
  
  public func clayMorpXLShadow() -> some View {
    self.fill(
      .shadow(.inner(color: Color.black.opacity(0.47), radius: 10, x: 0, y: -3))
      .shadow(.inner(color: Color.white.opacity(0.6), radius: 15, x: 3, y: 1))
      .shadow(.drop(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 7))
    )
  }
  
  public func mainImgShadow() -> some View {
    self.fill(
      .shadow(.inner(color: Color.black.opacity(0.47), radius: 20, x: 0, y: -3))
      .shadow(.inner(color: Color.white.opacity(0.6), radius: 30, x: 3, y: 1))
      .shadow(.drop(color: Color.pink500.opacity(0.12), radius: 20, x: 0, y: 12))
    )
  }
  
  // TODO: chekeup
  public func glassBG1Shadow() -> some View {
    self.fill(
      .shadow(.drop(color: Color.black.opacity(0.15), radius: 34, x: 0, y: 4))
    ).blur(radius: 6)
  }
  
  public func clayMorpMDPinkShadow() -> some View {
    self.fill(
      .shadow(.inner(color: Color.black.opacity(0.37), radius: 10, x: 0, y: -3))
      .shadow(.inner(color: Color.white.opacity(0.5), radius: 15, x: 3, y: 1))
      .shadow(.drop(color: Color.pink600.opacity(0.03), radius: 20, x: 0, y: 7))
    )
  }
  
  public func clayMorpBtnXLPinkShadow() -> some View {
    self.fill(
      .shadow(.inner(color: Color.black.opacity(0.37), radius: 10, x: 0, y: -3))
      .shadow(.inner(color: Color.white.opacity(0.5), radius: 15, x: 3, y: 1))
      .shadow(.drop(color: Color.pink100.opacity(1), radius: 40, x: 0, y: 20))
    )
  }
  
  public func clayMorpBtnGrayShadow() -> some View {
    self.fill(
      .shadow(.inner(color: Color.black.opacity(0.37), radius: 10, x: 0, y: -3))
      .shadow(.inner(color: Color.white.opacity(0.5), radius: 15, x: 3, y: 1))
      .shadow(.drop(color: Color.stone200.opacity(1), radius: 40, x: 0, y: 20))
    )
  }
  
}
