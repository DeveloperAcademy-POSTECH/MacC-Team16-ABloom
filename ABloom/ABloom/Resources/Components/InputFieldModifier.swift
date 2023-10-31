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
  var cornerRadius: CGFloat = 8.0
  
  public func body(content: Content) -> some View {
    ZStack(alignment: alignment) {
      RoundedRectangle(cornerRadius: cornerRadius)
        .stroke(
          isValueValid ? .purple600 : .purple500,
          lineWidth: isValueValid ? 1.5 : 1.0
        )
        .frame(height: 50)
        .background(.white)
        .cornerRadius(cornerRadius)
        .shadow(color: .purple600.opacity(0.1), radius: 20, x: 0, y: 7)

      content
        .foregroundStyle(isValueValid ? .stone900 : .stone400)
        .padding(.horizontal, 16)
    }
    .tint(.purple600)
  }
}
