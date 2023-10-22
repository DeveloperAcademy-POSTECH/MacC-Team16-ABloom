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
          isValueValid ? .pink500 : .biPink,
          lineWidth: isValueValid ? 1.5 : 1.0
        )
        .frame(height: 50)
        .background(.white)
        .cornerRadius(cornerRadius)
        
      content
        .foregroundStyle(isValueValid ? .stone900 : .stone400)
        .padding(.horizontal, 16)
    }
    .tint(.pink500)
  }
}
