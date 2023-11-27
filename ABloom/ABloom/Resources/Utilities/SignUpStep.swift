//
//  SignUpStep.swift
//  ABloom
//
//  Created by 정승균 on 11/17/23.
//

import Foundation

enum SignUpStep {
  case step1
  case step2
  case step3
  case step4
  
  var progress: CGFloat {
    switch self {
    case .step1:
      25
    case .step2:
      50
    case .step3:
      75
    case .step4:
      100
    }
  }
  
  var headlineText: String {
    switch self {
    case .step1:
      "가입 유형을 선택해주세요."
    case .step2:
      "결혼예정일을 알려주세요."
    case .step3:
      "이름을 알려주세요"
    case .step4:
      "마지막 단계예요."
    }
  }
  
  var subHeadlineText: String {
    switch self {
    case .step1:
      """
      메리는 예비부부를 위한 결혼문답 앱이에요.
      예비신랑인지 예비신부인지 선택해주세요.
      """
    case .step2:
      """
      결혼까지 남은 기간에 따라 문답을 추천해드릴게요.
      정확한 예정일이 없다면 대략적으로 선택해주세요.
      """
    case .step3:
      """
      메리가 회원님을 어떻게 불러드릴까요?
      작성한 이름은 연결된 상대방에게 공개돼요.
      """
    case .step4:
      """
      안전한 서비스 이용을 위해서,
      이용약관과 개인정보 처리방침을 확인해주세요.
      """
    }
  }
}
