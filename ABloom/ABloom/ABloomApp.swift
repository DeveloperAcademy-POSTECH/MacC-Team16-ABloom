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
  
  init() {
    Task {
      try? await UserManager.shared.fetchFianceUser()
      try? await UserManager.shared.fetchCurrentUser()
      try? await StaticQuestionManager.shared.fetchStaticQuestions()
      StaticQuestionManager.shared.fetchFilterQuestions()
      try? await EssentialQuestionManager.shared.fetchEssentialCollections()
      try? await AnswerManager.shared.fetchMyAnswers()
      try? await AnswerManager.shared.fetchFianceAnswers()
    }
    
    UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(named: "Purple 600")
  }
  
  @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
  @State var isLoading = true
  
  var body: some Scene {
    
    WindowGroup {
      NavigationStack {
        ZStack {
          if isLoading {
            SplashView()
          } else {
            QnAListView()
              .fullScreenCover(isPresented: $isFirstLaunching) {
                OnboardingTabView(isFirstLaunching: $isFirstLaunching)
              }
//              .sheet(isPresented: .constant(true), content: {
//                ProfileMenuView()
//              })
          }
        }
      }
      .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
        isLoading.toggle()
      })
      }
     
    }
  }
}
