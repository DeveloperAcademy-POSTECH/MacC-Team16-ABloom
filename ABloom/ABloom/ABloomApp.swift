//
//  ABloomApp.swift
//  ABloom
//
//  Created by yun on 10/11/23.
//
import Firebase
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
    
    UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(named: "Purple 600")
  }
  
  @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
  
  var body: some Scene {
    
    WindowGroup {
      NavigationStack {
        if isFirstLaunching {
          OnboardingTabView(isFirstLaunching: $isFirstLaunching)
        } else {
          QnAListView()
        }
      }
      
      /// 카카오톡에서 앱으로 돌아왔을 때 카카오 로그인 처리를 정상적으로 완료하기 위함
      .onOpenURL { url in
        if AuthApi.isKakaoTalkLoginUrl(url) {
          _ = AuthController.handleOpenUrl(url: url)
        }
      }
    }
  }
}
