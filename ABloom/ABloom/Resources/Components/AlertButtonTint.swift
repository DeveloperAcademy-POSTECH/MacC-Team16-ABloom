//
//  AlertButtonTint.swift
//  ABloom
//
//  Created by yun on 11/20/23.
//

import SwiftUI

struct AlertButtonTintColor: ViewModifier {
  let color: Color
  @State private var previousTintColor: UIColor?
  
  func body(content: Content) -> some View {
    content
      .onAppear {
        previousTintColor = UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(color)
      }
      .onDisappear {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = previousTintColor
      }
  }
}
