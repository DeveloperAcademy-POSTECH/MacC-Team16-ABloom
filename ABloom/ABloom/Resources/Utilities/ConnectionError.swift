//
//  ConnectionError.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/30/23.
//

/// 사용자 정의 에러 타입
enum ConnectionError: Error {
  case fianceAlreadyExists
  case invalidConnectionCode
  case selfConnection
  
  func errorMessage() -> String {
    switch self {
    case .fianceAlreadyExists:
      return "이미 연결된 상대방입니다."
    case .invalidConnectionCode:
      return "유효하지 않은 코드입니다."
    case .selfConnection:
      return "본인 아이디를 입력할 수 없습니다."
    }
  }
}
