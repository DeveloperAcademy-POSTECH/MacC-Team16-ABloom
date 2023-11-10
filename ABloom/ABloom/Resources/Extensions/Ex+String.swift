//
//  Ex+String.swift
//  ABloom
//
//  Created by yun on 11/9/23.
//

import SwiftUI

// For Text alignment - Justified
extension String {
  func useNonBreakingSpace() -> String {
    return self.replacingOccurrences(of: " ", with: "\u{202F}\u{202F}")
  }
}
