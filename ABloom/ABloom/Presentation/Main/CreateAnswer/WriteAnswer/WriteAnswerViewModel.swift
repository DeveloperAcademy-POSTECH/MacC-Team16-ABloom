//
//  WriteAnswerViewModel.swift
//  ABloom
//
//  Created by yun on 11/20/23.
//
import Combine
import Foundation
import StoreKit
import SwiftUI


@MainActor
class WriteAnswerViewModel: ObservableObject {
  @Published var isCancelAlertOn = Bool()
  @Published var isCompleteAlertOn = Bool()
  @Published var ansText: String = ""
  @Published var isTextOver = Bool()
  
  private var cancellables = Set<AnyCancellable>()
    
  private func requestReview() {
    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
      SKStoreReviewController.requestReview(in: scene)
    }
  }
  
  func checkTextCount() {
    // 맥시멈 제한
    if self.ansText.count >= 200 {
      self.ansText = String(self.ansText.prefix(200))
    }
    
    if self.ansText.count > 150 {
      self.isTextOver = true
    } else {
      self.isTextOver = false
    }
    
    self.checkSwipeDisable()
  }
  
  func swipeEnable() {
    UINavigationController.isSwipeBackEnabled = true
  }
  
  // 백스와이프 차단
  private func checkSwipeDisable() {
    if self.ansText == "" {
      UINavigationController.isSwipeBackEnabled = true
    } else {
      UINavigationController.isSwipeBackEnabled = false
    }
  }
  
  func backClicked() {
    if self.ansText != "" {
      self.isCancelAlertOn.toggle()
    }
  }
  
  func completeClicked() {
    self.isCompleteAlertOn.toggle()
  }
  
  func createAnswer(qid: Int, category: String) throws {
    let uid = try AuthenticationManager.shared.getAuthenticatedUser().uid
    try AnswerManager.shared.createAnswer(userId: uid, questionId: qid, content: self.ansText)
    MixpanelManager.qnaAnswer(letterCount: ansText.count, category: category, questionId: qid)
  }
  
  // MARK: - ReviewPopUp 관련
  
  // '나'가 작성한 문답 갯수 카운트
  func observeAnswerCount() {
    AnswerManager.shared.$myAnswers
      .sink { [weak self] myAnswers in
        let totalCount = myAnswers?.count ?? 0
        self?.checkReviewRequest(totalCount: totalCount)
      }
      .store(in: &cancellables)
  }
  
  private func checkReviewRequest(totalCount: Int) {
    if totalCount == 5 || totalCount == 20 || totalCount == 50 {
      requestReview()
    }
  }
  
}
