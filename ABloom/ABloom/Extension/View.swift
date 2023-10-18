//
//  View.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/18/23.
//

import SwiftUI

extension View {
  func strokeInputFieldStyle(isValueValid: Bool, alignment: Alignment) -> some View {
    modifier(StrokeInputFieldStyle(isValueValid: isValueValid, alignment: alignment))
  }
}
