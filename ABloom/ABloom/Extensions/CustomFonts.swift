import SwiftUI


/// Custom Font 사용방법



func checkFonts(){
  
  // font 확인
  for family in UIFont.familyNames.sorted() {
    let names = UIFont.fontNames(forFamilyName: family)
    print("Family: \(family) Font names: \(names)")
  }
}

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

struct CustomText: View{
  var text: String
  var value: CGFloat = 1
  
  var body: some View{
    return Text(text)
      .tracking(value)
  }
}
