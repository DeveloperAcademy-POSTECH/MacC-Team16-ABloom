//
//  MarriageStatus.swift
//  ABloom
//
//  Created by 정승균 on 11/20/23.
//

import Foundation

enum MarriageStatus {
  case notMarried(Int)
  case married(Int)
  case dday
  
  var dDayMessage: String {
    switch self {
    case .notMarried(let day):
      "결혼까지 \(day)일 남았어요."
    case .married(let day):
      "결혼한지 \(day)일 지났어요."
    case .dday:
      "결혼을 축하드려요!"
    }
  }
}
