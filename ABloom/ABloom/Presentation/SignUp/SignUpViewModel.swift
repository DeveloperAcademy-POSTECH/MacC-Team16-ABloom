//
//  SignUpViewModel.swift
//  ABloom
//
//  Created by 정승균 on 11/17/23.
//

import SwiftUI

final class SignUpViewModel: ObservableObject {
  @Published var nowStep: SignUpStep = .step1
  @Published var selectedSex: UserSexType = .none
  @Published var selectedDate: Date = .now
  @Published var inputName: String = ""
  @Published var isCheckedPrivacyPolicy = false
  @Published var isCheckedTermsOfuse = false
  
  func stepToNext() {
    switch nowStep {
    case .step1:
      self.nowStep = .step2
    case .step2:
      self.nowStep = .step3
    case .step3:
      self.nowStep = .step4
    case .step4:
      return
    }
  }
  
  func stepToBack() {
    switch nowStep {
    case .step1:
      return
    case .step2:
      self.nowStep = .step1
    case .step3:
      self.nowStep = .step2
    case .step4:
      self.nowStep = .step3
    }
  }
  
  func nextButtonColor() -> Color {
    if nextButtonDisableStatus() {
      Color.gray400
    } else {
      Color.purple700
    }
  }
  
  func nextButtonDisableStatus() -> Bool {
    switch nowStep {
    case .step1, .step2:
      false
    case .step3:
      self.inputName.isEmpty
    case .step4:
      !self.isCheckedPrivacyPolicy || !self.isCheckedTermsOfuse
    }
  }
}
