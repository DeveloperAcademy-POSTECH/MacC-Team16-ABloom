import SwiftUI

extension Font {
  // LargeTitle
  static let largeTitle: Font = .custom("SpoqaHanSansNeo-Regular", size: 34)
  
  // Titles
  static let title1: Font = .custom("SpoqaHanSansNeo-Regular", size: 28)
  static let title2: Font = .custom("SpoqaHanSansNeo-Regular", size: 22)
  static let title3: Font = .custom("SpoqaHanSansNeo-Regular", size: 20)
  
  // Others
  static let headline: Font = .custom("SpoqaHanSansNeo-Regular", size: 17)
  static let body: Font = .custom("SpoqaHanSansNeo-Regular", size: 17)
  static let callout: Font = .custom("SpoqaHanSansNeo-Regular", size: 16)
  static let subHeadline: Font = .custom("SpoqaHanSansNeo-Regular", size: 15)
  static let footnote: Font = .custom("SpoqaHanSansNeo-Regular", size: 13)
  static let caption1: Font = .custom("SpoqaHanSansNeo-Regular", size: 12)
  static let caption2: Font = .custom("SpoqaHanSansNeo-Regular", size: 11)
}

extension Text {
  /**
   Custom Font
   1. bold체의 경우 .bold()를 폰트 뒤에 추가
   2. 모든 Text는 자간이 1 혹은 -0.4 이므로 아래의 Modifier에 value가 1 혹은 -0.4로 적용되어야 함
   
   사용예제
   -
   .fontWithTracking(fontStyle: .largeTitle.bold(), value: 1)
   */
  func fontWithTracking(fontStyle: Font, value: CGFloat) -> Text {
    self.font(fontStyle)
      .tracking(value)
  }
}
