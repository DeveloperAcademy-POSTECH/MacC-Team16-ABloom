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
  
  //  init() {
  ////    FirebaseApp.configure()
  //    // TODO: Local + Firebase 합치기
  ////    requestNotificationPermission()
  //    
  //    print("Firebase configured!")
  //  }
  
  var body: some Scene {
    WindowGroup {
      TabBarView()
    }
  }
}
