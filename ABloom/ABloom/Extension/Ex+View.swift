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
}
