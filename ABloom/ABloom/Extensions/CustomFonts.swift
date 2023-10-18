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
  
  
  // LargeTitleBold
  static let largeTitleBold: Font = .custom("SpoqaHanSansNeo-Bold", size: 34)
  
  // TitlesBold
  static let title1Bold: Font = .custom("SpoqaHanSansNeo-Bold", size: 28)
  static let title2Bold: Font = .custom("SpoqaHanSansNeo-Bold", size: 22)
  static let title3Bold: Font = .custom("SpoqaHanSansNeo-Medium", size: 20)
  
  // OthersBold
  static let headlineBold: Font = .custom("SpoqaHanSansNeo-Bold", size: 17)
  static let bodyBold: Font = .custom("SpoqaHanSansNeo-Medium", size: 17)
  static let calloutBold: Font = .custom("SpoqaHanSansNeo-Medium", size: 16)
  static let subHeadlineBold: Font = .custom("SpoqaHanSansNeo-Medium", size: 15)
  static let footnoteBold: Font = .custom("SpoqaHanSansNeo-Regular", size: 13)
  static let caption1Bold: Font = .custom("SpoqaHanSansNeo-Medium", size: 12)
  static let caption2Bold: Font = .custom("SpoqaHanSansNeo-Medium", size: 11)
}

extension Text {
  /**
   Custom Font
   - 모든 Text는 자간이 1 혹은 -0.4 이므로 아래의 Modifier에 value가 1 혹은 -0.4로 적용되어야 함
   
   사용예제
   -
   .fontWithTracking(fontStyle: .largeTitleBold, value: 1)
   */
  func fontWithTracking(fontStyle: Font, value: CGFloat = 1) -> Text {
    self.font(fontStyle)
      .tracking(value)
  }
}
