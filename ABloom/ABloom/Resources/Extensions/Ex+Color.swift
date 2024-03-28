//
//  Ex+Color.swift
//  ABloom
//
//  Created by yun on 11/20/23.
//

import SwiftUI

extension Color {
  init(hex: Int, opacity: Double = 1.0) {
    let red = Double((hex >> 16) & 0xff) / 255
    let green = Double((hex >> 8) & 0xff) / 255
    let blue = Double((hex >> 0) & 0xff) / 255
    
    self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
  }
  
  static let background: Color = .primary5
}
