//
//  ABloomApp.swift
//  ABloom
//
//  Created by yun on 10/11/23.
//

import FirebaseCore
import SwiftUI

@main
struct ABloomApp: App {
  
  init() {
    FirebaseApp.configure()
    print("Firebase configured!")
  }
  
  var body: some Scene {
    WindowGroup {
      TabBarView()
    }
  }
}
