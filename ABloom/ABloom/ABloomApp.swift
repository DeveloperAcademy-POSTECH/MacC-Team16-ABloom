//
//  ABloomApp.swift
//  ABloom
//
//  Created by yun on 10/11/23.
//
import SwiftUI

import ComposableArchitecture

@main
struct ABloomApp: App {
  static let store = Store(initialState: MainViewFeature.State()) {
    MainViewFeature()
  }
  var body: some Scene {
    WindowGroup {
      MainView(store: ABloomApp.store)
    }
  }
}
