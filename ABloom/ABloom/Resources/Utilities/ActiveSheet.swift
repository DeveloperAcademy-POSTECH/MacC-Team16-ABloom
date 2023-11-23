//
//  ActiveSheet.swift
//  ABloom
//
//  Created by Lee Jinhee on 11/21/23.
//

// TODO: 로그인 팝업 창 모듈화하기

import Foundation
import SwiftUI

final class ActiveSheet: ObservableObject {
  enum Kind {
    case signIn
    case signUp
    case none
  }
  
  @Published var kind: Kind = .none {
    didSet { showSheet = kind != .none }
  }
  @Published var showSheet: Bool = false
  
  
  func checkSheet() -> some View {
    switch self.kind {
    case .none: return AnyView(EmptyView())
    case .signIn: return AnyView(signInSheet())
    case .signUp: return AnyView(signUpSheet())
    }
  }
  
  func signInSheet() -> some View {
    return SignInView(activeSheet: self)
      .presentationDetents([.height(302)])
      .onDisappear {
        Task { await self.fetchDataAfterSignIn()  }
      }
  }
  
  func signUpSheet() -> some View {
    return SignUpView()
      .interactiveDismissDisabled()
      .onDisappear {
        Task { await self.fetchDataAfterSignIn() }
      }
  }
  
  
  private func fetchDataAfterSignIn() async {
    Task {
      try? await UserManager.shared.fetchCurrentUser()
      try? await UserManager.shared.fetchFianceUser()
      try? await StaticQuestionManager.shared.fetchStaticQuestions()
      StaticQuestionManager.shared.fetchFilterQuestions()
      try? await EssentialQuestionManager.shared.fetchEssentialCollections()
      try? await AnswerManager.shared.fetchMyAnswers()
      try? await AnswerManager.shared.fetchFianceAnswers()
    }
  }
  
}
