//
//  InputFieldModifier.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/18/23.
//

import SwiftUI

struct StrokeInputFieldStyle: ViewModifier {
  let isValueValid: Bool
  let alignment: Alignment
  var cornerRadius: CGFloat = 12.0
  
  public func body(content: Content) -> some View {
    ZStack(alignment: alignment) {
      RoundedRectangle(cornerRadius: cornerRadius)
        .stroke(
          isValueValid ? .primary40 : .primary20,
          lineWidth: 4
        )
        .frame(height: 50)
        .background(.white)
        .cornerRadius(cornerRadius)

      content
        .customFont(isValueValid ? .calloutB : .calloutR)
        .foregroundStyle(isValueValid ? .gray500 : .gray400)
        .padding(.horizontal, 15)
    }
    .tint(.primary40)
  }
}
