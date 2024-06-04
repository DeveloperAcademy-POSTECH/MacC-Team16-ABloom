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
  
  /// RoundedCorner struct를 활용하여 지정된 edge마다 지정된 radius 값으로 변환시키는 함수
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape( RoundedCorner(radius: radius, corners: corners) )
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
