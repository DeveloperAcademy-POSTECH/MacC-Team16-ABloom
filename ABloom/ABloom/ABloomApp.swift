//
//  ABloomApp.swift
//  ABloom
//
//  Created by yun on 10/11/23.
//
import Firebase
import GoogleSignIn
import KakaoSDKAuth
import SwiftUI


@main
struct ABloomApp: App {
  // TODO: Notificaiton을 위한 자료
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  init() {
    Task {
      try? await UserManager.shared.fetchCurrentUser()
      try? await UserManager.shared.fetchFianceUser()
      try? await StaticQuestionManager.shared.fetchStaticQuestions()
      StaticQuestionManager.shared.fetchFilterQuestions()
      try? await EssentialQuestionManager.shared.fetchEssentialCollections()
      AnswerManager.shared.addSnapshotListenerForMyAnswer()
      AnswerManager.shared.addSnapshotListenerForFianceAnswer()
    }
    
    UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(named: "Primary 60")
  }
  
  
  var body: some Scene {
    
    WindowGroup {
      NavigationStack {
          QnAListView()
      }
      
      /// 구글웹, 카카오톡에서 앱으로 돌아왔을 때 로그인 처리를 정상적으로 완료하기 위함
      .onOpenURL { url in
        if AuthApi.isKakaoTalkLoginUrl(url) {
          _ = AuthController.handleOpenUrl(url: url)
        } else {
          GIDSignIn.sharedInstance.handle(url)
        }
      }
    }
  }
}
