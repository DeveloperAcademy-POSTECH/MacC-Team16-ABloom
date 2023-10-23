//
//  Ex+Text.swift
//  ABloom
//
//  Created by yun on 10/19/23.
//

import SwiftUI

extension Text {
  /**
   Custom Font
   - 모든 Text는 자간이 1 혹은 -0.4 이므로 아래의 Modifier에 value가 1 혹은 -0.4로 적용되어야 함
   
   사용예제
   -
   .fontWithTracking(fontStyle: .largeTitleBold, value: 1)
   */
  func fontWithTracking(fontStyle: Font, value: CGFloat = 1) -> Text {
    self.font(fontStyle)
      .tracking(value)
  }

}
