//
//  ABloomApp.swift
//  ABloom
//
//  Created by yun on 10/11/23.
//
import Firebase
import SwiftUI


@main
struct ABloomApp: App {
  // TODO: Notificaiton을 위한 자료 -> Sprint2 진행
  // @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
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
