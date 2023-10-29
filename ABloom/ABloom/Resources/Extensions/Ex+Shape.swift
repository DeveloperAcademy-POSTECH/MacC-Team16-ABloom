//
//  GradientColors.swift
//  ABloom
//
//  Created by yun on 10/17/23.
//

import SwiftUI

extension Color {
  public func exampleShadow() -> some ShapeStyle {
    self
      .shadow(.inner(color: Color.black.opacity(0.15), radius: 10, x: 0, y: -3))
      .shadow(.inner(color: Color.white.opacity(0.25), radius: 15, x: 3, y: 1))
      .shadow(.drop(color: Color.black.opacity(0.015), radius: 20, x: 0, y: 7))
  }
  
}

extension Shape {
  
  /***
   Customized Shadows
   - Shape에 대한 Modifier로 적용
   
   총 7개의 함수 존재
   1. clayMorpMDShadow()
   2. clayMorpXLShadow()
   3. mainImgShadow()
   4. glassBG1Shadow()
   5. clayMorpMDPinkShadow()
   6. clayMorpBtnXLPinkShadow()
   7. clayMorpBtnGrayShadow()
   
   사용예제
   -
   Rectangle()
   .clayMorpMDShadow()
   
   피그마와 다르게 적용할 점
   - radius = radius / 2
   - 실행시켜보고 다르게 보인다면 최대한 비슷하도록 수치 조정
   */
  
  // 완료
  public func clayMorpMDShadow() -> some View {
    self.fill(
      .shadow(.inner(color: Color.black.opacity(0.36), radius: 5, x: 0, y: -3))
      .shadow(.inner(color: Color.white.opacity(0.5), radius: 7.5, x: 3, y: 1))
      .shadow(.drop(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 7))
    )
  }
  
  // 사용 X
  public func clayMorpXLShadow() -> some View {
    self.fill(
      .shadow(.inner(color: Color.black.opacity(0.03), radius: 10, x: 0, y: -3))
      .shadow(.inner(color: Color.white.opacity(0.6), radius: 15, x: 3, y: 1))
      .shadow(.drop(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 7))
    )
  }
  
  public func mainImgShadow() -> some View {
    self.fill(
      .shadow(.inner(color: Color.black.opacity(0.03), radius: 20, x: 0, y: -3))
      .shadow(.inner(color: Color.white.opacity(0.6), radius: 30, x: 3, y: 1))
      .shadow(.drop(color: Color.pink500.opacity(0.12), radius: 20, x: 0, y: 12))
    )
  }
  
  // 완료
  public func glassBG1Shadow() -> some View {
    self.fill(
      .shadow(.drop(color: Color.black.opacity(0.1), radius: 12.5, x: 0, y: 4))
    )
    .background(blur(radius: 60))
  }
  
  // 사용 X - 버튼 컴포넌트에서 활용
  public func clayMorpMDPinkShadow() -> some View {
    self.fill(
      .shadow(.inner(color: Color.black.opacity(0.03), radius: 10, x: 0, y: -3))
      .shadow(.inner(color: Color.white.opacity(0.5), radius: 15, x: 3, y: 1))
      .shadow(.drop(color: Color.pink600.opacity(0.03), radius: 20, x: 0, y: 7))
    )
  }
  
  // 사용 X - 버튼 컴포넌트에서 활용
  public func clayMorpBtnXLPinkShadow() -> some View {
    self.fill(
      .shadow(.inner(color: Color.black.opacity(0.03), radius: 10, x: 0, y: -3))
      .shadow(.inner(color: Color.white.opacity(0.5), radius: 15, x: 3, y: 1))
      .shadow(.drop(color: Color.pink100.opacity(1), radius: 40, x: 0, y: 20))
    )
  }
  
  // 완료 - 버튼 컴포넌트에서 활용
  public func clayMorpBtnGrayShadow() -> some View {
    self.fill(
      .shadow(.inner(color: Color.black.opacity(0.08), radius: 5, x: 0, y: -3))
      .shadow(.inner(color: Color.white.opacity(0.5), radius: 7.5, x: 3, y: 1))
    )
    .shadow(color: Color.stone200.opacity(1), radius: 20, x: 0, y: 20)
  }
  
  // 완료 - 버튼 컴포넌트에서 활용
  public func clayMorpBtnXLPurpleShadow() -> some View {
    self.fill(
      .shadow(.inner(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -3))
      .shadow(.inner(color: Color.white.opacity(0.5), radius: 7.5, x: 3, y: 1))
    )
    .shadow(color: Color.purple200.opacity(1), radius: 20, x: 0, y: 20)
  }
  
  // 완료
  public func loginChatBubbleShadow() -> some View {
    self.fill(
      .shadow(.inner(color: Color.black.opacity(0.06), radius: 5, x: 0, y: -3))
      .shadow(.inner(color: Color.white.opacity(0.6), radius: 8, x: 3, y: 1))
    )
    .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 7.45)
  }
}
