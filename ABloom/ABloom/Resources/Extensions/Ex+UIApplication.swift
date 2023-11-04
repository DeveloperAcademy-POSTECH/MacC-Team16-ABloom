//
//  Ex+UIApplication.swift
//  ABloom
//
//  Created by 정승균 on 11/5/23.
//

import Foundation
import SwiftUI

extension UIApplication {
  func hideKeyboard() {
    let windowScene = connectedScenes.first as? UIWindowScene
    guard let window = windowScene?.windows.first else { return }
    let tapRecognizer = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
    tapRecognizer.cancelsTouchesInView = false
    tapRecognizer.delegate = self
    window.addGestureRecognizer(tapRecognizer)
  }
}

extension UIApplication: UIGestureRecognizerDelegate {
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return false
  }
}
