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
          isValueValid ? .red : .pink,
          lineWidth: isValueValid ? 2.5 : 1.0
        )
        
      content
        .foregroundStyle(isValueValid ? .black : .gray)
        .padding(
          EdgeInsets(
            top: 0,
            leading: alignment == .leading ? 16 : 0,
            bottom: 0,
            trailing: alignment == .trailing ? 16 : 0)
        )
    }
    .frame(height: 50)
    .background(.white)
  }
}
