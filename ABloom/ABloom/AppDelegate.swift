//
//  AppDelegate.swift
//  ABloom
//
//  Created by yun on 10/31/23.
//

import Firebase
import FirebaseCore
import FirebaseMessaging
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
  
  // 앱이 켜졌을 때 자동 실행
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    
    // 파이어베이스 설정
    FirebaseApp.configure()
    
    // 알림 허용 권한 및 파이어베이스 메시징 정리
    requestNotificationPermission()
    
    Messaging.messaging().delegate = self
    
    return true
  }
  
  // 원격 알림을 등록했을 때 불러옴
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // Firebase Cloud Messaging 서비스에 토큰 전달
    Messaging.messaging().apnsToken = deviceToken
  }
  
  func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      
      if granted {
        self.scheduleDailyNotification()
        
        if let fcmToken = Messaging.messaging().fcmToken {
          try? self.updatefcmToken(fcmToken: fcmToken)
          print("token achieved")
        } else {
          print("empty Token")
        }
        print("granted")
      } else {
        // Handle the case where permission was denied
      }
    }
  }
  
  func scheduleDailyNotification() {
    let content = UNMutableNotificationContent()
    content.title = "오늘의 추천 질문을 확인해보세요"
    content.body = "답변을 작성하고 서로의 생각을 알아볼까요?"
    
    var dateComponents = DateComponents()
    dateComponents.timeZone = TimeZone(identifier: "Asia/Seoul")
    
    dateComponents.hour = 9
    dateComponents.minute = 0
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    print(dateComponents)
    
    let request = UNNotificationRequest(identifier: "dailyNotification", content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { error in
      if let error = error {
        print("Error scheduling notification: \(error)")
      }
    }
    
    
  }
}

extension AppDelegate: MessagingDelegate {
  
  // 파이어베이스 MessagingDelegate 설정
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    
    print("토큰을 받았다")
    // Store this token to firebase and retrieve when to send message to someone...
    let dataDict: [String: String] = ["token": fcmToken ?? ""]
    
    // Store token in Firestore For Sending Notifications From Server in Future...
//    if let fcmToken = fcmToken {
//      do {
//        try updatefcmToken(fcmToken: fcmToken)
//        print("Token updated successfully")
//      } catch {
//        print("Error updating FCM token: \(error)")
//      }
//    }
    
    
    print(dataDict)
  }
  
  private func updatefcmToken(fcmToken: String) throws {
    let myId: String = try AuthenticationManager.shared.getAuthenticatedUser().uid
    try UserManager.shared.updateFcmToken(userID: myId, fcmToken: fcmToken)
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
    
    
    completionHandler([[.banner, .badge, .sound]])
  }
  
  // 푸시메세지를 받았을 때
  // 메시지를 받고 앱에서 진행하는 액션
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    
    // Do Something With MSG Data... 예제
    
    completionHandler()
  }
}
