//
//  Ex+Date.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/31/23.
//

import Foundation

extension Date: RawRepresentable {
  public var rawValue: String {
    self.timeIntervalSinceReferenceDate.description
  }
  
  public init?(rawValue: String) {
    self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
  }
  
  public func formatToYMD() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 MM월 dd일"
    return formatter.string(from: self)
  }
  
  public func isSameDate(lastChangedDate: Date) -> Bool {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
    
    let selfComponents = calendar.dateComponents([.year, .month, .day], from: self)
    let lastChangedDateComponents = calendar.dateComponents([.year, .month, .day], from: lastChangedDate)
    
    return selfComponents == lastChangedDateComponents
  }
  
  public func calculateDDay(with date: Date) -> Int {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
    
    let selfComponents = calendar.dateComponents([.year, .month, .day], from: self)
    let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
    
    guard let dDay = Calendar.current.dateComponents([.day], from: selfComponents, to: dateComponents).day else { return 0 }
    
    return dDay
  }
}
