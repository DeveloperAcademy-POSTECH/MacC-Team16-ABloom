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
  // TODO: Notificaiton을 위한 자료
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
  
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        SignUpView()
          .fullScreenCover(isPresented: $isFirstLaunching) {
            OnboardingTabView(isFirstLaunching: $isFirstLaunching)
          } 
      }
    }
  }
}
