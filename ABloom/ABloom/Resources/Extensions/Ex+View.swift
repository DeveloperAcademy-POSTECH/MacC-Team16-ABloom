//
//  Ex+View.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/18/23.
//

import SwiftUI

extension View {
  
  /// Stroke를 가지는 입력창에 사용되는 View입니다.
  ///
  /// - Parameters:
  ///   - isValueValid: 입력값의 유효 여부에 따라 뷰의 상태가 변경됩니다. `true`인 경우 활성화된 스타일을, `false`인 경우 플레이스홀더와 유사한 스타일을 반환합니다.
  ///   - alignment: ZStack 내에서 뷰의 정렬을 지정합니다.
  ///   - cornerRadius: RoundedRectangle의 모서리 반경을 설정합니다. 기본값은 8.0입니다.
  /// - Returns: StrokeInputField 형태의 View가 반환됩니다.
  ///
  ///  ````
  ///     @State var name: String = ""
  ///     var isNameValid: Bool {
  ///       return !name.isEmpty
  ///     }
  ///
  ///     TextField("홍길동", text: name)
  ///       .strokeInputFieldStyle(isValueValid: isNameValid, alignment: .leading)
  ///  ````
  func strokeInputFieldStyle(isValueValid: Bool, alignment: Alignment, cornerRadius: CGFloat = 8.0) -> some View {
    modifier(StrokeInputFieldStyle(isValueValid: isValueValid, alignment: alignment, cornerRadius: cornerRadius))
  }
  
  /***
   Customized GradientColors
   - ShapeStyle의 형태를 지님
   
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
  public func blueGradient54() -> some ShapeStyle {
    LinearGradient(colors: [.blue500, .blue400], startPoint: .bottomLeading, endPoint: .topTrailing)
  }
  /// Blue400 - Blue300 Gradient
  public func blueGradient43() -> some ShapeStyle {
    LinearGradient(colors: [.blue400, .biBlue], startPoint: .bottomLeading, endPoint: .topTrailing)
  }
  /// Pink500 - Pink400 Gradient
  public func pinkGradient54() -> some ShapeStyle {
    LinearGradient(colors: [.pink500, .pink400], startPoint: .bottomLeading, endPoint: .topTrailing)
  }
  /// Pink400 - Pink300 Gradient
  public func pinkGradient43() -> some ShapeStyle {
    LinearGradient(colors: [.pink400, .biPink], startPoint: .bottomLeading, endPoint: .topTrailing)
  }
  /// Purple600 - Purple500 Gradient
  public func purpleGradient65() -> some ShapeStyle {
    LinearGradient(colors: [.primary60, .primary50], startPoint: .bottomLeading, endPoint: .topTrailing)
  }
  
  public func glassGradient() -> some ShapeStyle {
    LinearGradient(colors: [.white, .white.opacity(0.0)], startPoint: .topLeading, endPoint: .bottomTrailing)
  }
  
  /// RoundedCorner struct를 활용하여 지정된 edge마다 지정된 radius 값으로 변환시키는 함수
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape( RoundedCorner(radius: radius, corners: corners) )
  }
  
  /// QnABackWall
  func backWall() -> some View {
    RoundedRectangle(cornerRadius: 20)
      .glassBG1Shadow()
      .foregroundStyle(glassGradient())
  }
  
  func fontWithTracking(_ fontStyle: Font, tracking: CGFloat = 1, lineSpacing: CGFloat = 5) -> some View {
    self
      .font(fontStyle)
      .lineSpacing(lineSpacing)
      .tracking(tracking)
  }
  
  func hidden(_ by: Bool) -> some View {
    modifier(Hidden(hidden: by))
  }
  
  
  // MARK: - 2.0에서 사용
  
  /// customNavigationBar
  func customNavigationBar<C, L, R>(
    centerView: @escaping (() -> C),
    leftView: @escaping (() -> L),
    rightView: @escaping (() -> R)
  ) -> some View where C: View, L: View, R: View {
    modifier(
      CustomNavigationBarModifier(centerView: centerView, leftView: leftView, rightView: rightView)
    )
  }
  
  
  func customFont(_ fontStyle: Font) -> some View {
    self
      .font(fontStyle)
      .lineSpacing(7) // 160% 적용하기
      .tracking(-0.4)
  }
  
  /// textField Placeholder customize
  func placeholder<Content: View>(
    when shouldShow: Bool,
    alignment: Alignment = .leading,
    @ViewBuilder placeholder: () -> Content) -> some View {
      
      ZStack(alignment: alignment) {
        placeholder().opacity(shouldShow ? 1 : 0)
        self
      }
    }
}


// TODO: 이 아이는 왜 여기에 있죠..0.0
struct Hidden: ViewModifier {
  var hidden: Bool
  
  func body(content: Content) -> some View {
    if hidden {
      content
        .hidden()
    } else {
      content
    }
  }
}
