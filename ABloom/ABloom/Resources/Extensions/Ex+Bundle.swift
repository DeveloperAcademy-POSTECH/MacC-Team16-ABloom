//
//  Ex+Bundle.swift
//  ABloom
//
//  Created by Lee Jinhee on 11/26/23.
//

import Foundation

extension Bundle {
  var kakaoApiKey: String {
    /// forResource = plist 파일 이름
    guard let filePath = Bundle.main.path(forResource: "Kakao-Info", ofType: "plist"),
          let plistDict = NSDictionary(contentsOfFile: filePath) else {
      fatalError("Couldn't find file 'Kakao-Info.plist'.")
    }
    
    /// plist 안쪽에 사용할 Key값
    guard let value = plistDict.object(forKey: "KakaoNativeAppkey") as? String else {
      fatalError("Couldn't find key 'API_Key' in 'SecureAPIKeys.plist'.")
    }
    
    return value
  }
}
