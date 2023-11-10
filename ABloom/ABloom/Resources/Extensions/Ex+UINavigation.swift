//
//  Ex+UINavigation.swift
//  ABloom
//
//  Created by yun on 11/3/23.
//

import SwiftUI

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
  static var isSwipeBackEnabled = true
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    navigationBar.isHidden = true
    interactivePopGestureRecognizer?.delegate = self
  }
  
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1 && Self.isSwipeBackEnabled
  }
}
