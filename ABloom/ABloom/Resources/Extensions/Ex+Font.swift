import SwiftUI

enum AppFont: String {
  case regular = "NanumSquareNeoTTF-bRg"
  case bold = "NanumSquareNeoTTF-cBd"
  case extraBold = "NanumSquareNeoTTF-dEb"
}

extension Font {
    
  // LargeTitle
  static let largeTitleR: Font = .custom(AppFont.regular.rawValue, size: 34)
  static let largeTitleB: Font = .custom(AppFont.bold.rawValue, size: 34)
  static let largeTitleXB: Font = .custom(AppFont.extraBold.rawValue, size: 34)
  
  // Titles
  static let title1R: Font = .custom(AppFont.regular.rawValue, size: 28)
  static let title1B: Font = .custom(AppFont.bold.rawValue, size: 28)
  
  static let title2R: Font = .custom(AppFont.regular.rawValue, size: 22)
  static let title2B: Font = .custom(AppFont.bold.rawValue, size: 22)
  
  static let title3R: Font = .custom(AppFont.regular.rawValue, size: 20)
  static let title3B: Font = .custom(AppFont.bold.rawValue, size: 20)
 
  // Others
  static let headlineR: Font = .custom(AppFont.regular.rawValue, size: 17)
  static let headlineB: Font = .custom(AppFont.bold.rawValue, size: 17)
  
  static let bodyR: Font = .custom(AppFont.regular.rawValue, size: 17)
  static let bodyB: Font = .custom(AppFont.bold.rawValue, size: 17)
  
  static let calloutR: Font = .custom(AppFont.regular.rawValue, size: 16)
  static let calloutB: Font = .custom(AppFont.bold.rawValue, size: 16)
  
  static let subHeadlineR: Font = .custom(AppFont.regular.rawValue, size: 15)
  static let subHeadlineB: Font = .custom(AppFont.bold.rawValue, size: 15)
  
  static let footnoteR: Font = .custom(AppFont.regular.rawValue, size: 13)
  static let footnoteB: Font = .custom(AppFont.bold.rawValue, size: 13)
  
  static let caption1R: Font = .custom(AppFont.regular.rawValue, size: 12)
  static let caption1B: Font = .custom(AppFont.bold.rawValue, size: 12)
  
  static let caption2R: Font = .custom(AppFont.regular.rawValue, size: 11)
  static let caption2B: Font = .custom(AppFont.bold.rawValue, size: 11)

  static let reaction14: Font = .custom("NPS-font-Regular", size: 14)
  static let reaction16: Font = .custom("NPS-font-Regular", size: 16)
  
  static let notice: Font = .custom(AppFont.regular.rawValue, size: 14)

  // Invitation Code
  static let myCode: Font = .custom(AppFont.extraBold.rawValue, size: 24)
}
