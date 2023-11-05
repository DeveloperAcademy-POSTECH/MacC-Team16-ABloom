//
//  AppDelegate.swift
//  ABloom
//
//  Created by yun on 10/31/23.
//

import Firebase
import FirebaseCore
import FirebaseMessaging

// Configuring Firebase Push Notification...

class AppDelegate: NSObject, UIApplicationDelegate {
  
  // 예시 키
  let gcmMessageIDKey = "gcm.message_id"
  
  // 앱이 켜졌을 때
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    
    // 파이어베이스 설정
    FirebaseApp.configure()
    
    // 앱 실행 시 사용자에게 알림 허용 권한을 받음
    UNUserNotificationCenter.current().delegate = self
    
    let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOption,
      completionHandler: {_, _ in })
    
    // UNUserNotificationCenterDelegate를 구현한 메서드를 실행시킴
    application.registerForRemoteNotifications()
    
    // 파이어베이스 Meesaging 설정
    Messaging.messaging().delegate = self
    
    UNUserNotificationCenter.current().delegate = self
    
    return true
  }
  
  // 백그라운드에서 푸시 알림을 탭했을 때 실행
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // Firebase Cloud Messaging 서비스에 토큰 전달
    Messaging.messaging().apnsToken = deviceToken
  }
}

extension AppDelegate: MessagingDelegate {
  
  // 파이어베이스 MessagingDelegate 설정
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    
    print("토큰을 받았다")
    // Store this token to firebase and retrieve when to send message to someone...
    let dataDict: [String: String] = ["token": fcmToken ?? ""]
    // Store token in Firestore For Sending Notifications From Server in Future...
    
    print(dataDict)
    
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  
  // Foreground(앱 켜진 상태)에서도 알림 오는 설정
  // 알림 설정 진행하는 곳
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                              -> Void) {
    
    let userInfo = notification.request.content.userInfo
    
    
    // Do Something With MSG Data... 예제
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    print(userInfo)
    
    completionHandler([[.banner, .badge, .sound]])
  }
  
  // 푸시메세지를 받았을 때
  // 메시지를 받고 앱에서 진행하는 액션
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    
    // Do Something With MSG Data... 예제
    
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    
    print(userInfo)
    
    completionHandler()
  }
}
