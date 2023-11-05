//
//  LocalPushNotification.swift
//  ABloom
//
//  Created by yun on 11/5/23.
//

import UserNotifications

// MARK: AppDelegate 파일에서 Firebase쪽 통신과 함께 다뤄야 하는데, Ref을 진행하여서 일단 파일하나에 관련 함수 정리해두었습니다.


func requestNotificationPermission() {
  UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
    
    // 변수를 설정에서 셋팅한다면, 변수로 확인해서 데일리 알림을 온/오프 할 수 있을 듯
    
    if granted {
      scheduleDailyNotification()
      print("granted")
    } else {
      // Handle the case where permission was denied
    }
  }
}

func scheduleDailyNotification() {
  let content = UNMutableNotificationContent()
  content.title = "추천 질문"
  content.body = "오늘의 추천 질문을 확인하고, 서로에 대해 알아보는 시간을 가져보세요."
  
  var dateComponents = DateComponents()
  dateComponents.timeZone = TimeZone(identifier: "Asia/Seoul")
  
  // 임의로 설정한 시간! 저녁 9시 50분 => 먼가 퇴근하고 쉬고 있을 것 같은 시간,,
  dateComponents.hour = 21
  dateComponents.minute = 50
  
  let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
  print(dateComponents)
  
  let request = UNNotificationRequest(identifier: "dailyNotification", content: content, trigger: trigger)
  
  UNUserNotificationCenter.current().add(request) { error in
    if let error = error {
      print("Error scheduling notification: \(error)")
    }
  }
}
