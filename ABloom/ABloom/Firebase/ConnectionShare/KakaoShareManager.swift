//
//  KakaoShareManager.swift
//  ABloom
//
//  Created by 정승균 on 2/18/24.
//

import Foundation
import KakaoSDKShare
import SafariServices

@MainActor
final class KakaoShareManager: NSObject {
  func shareMyCode() {
    let templateId: Int64 = 103009
    
    guard let userName = UserManager.shared.currentUser?.name else { return }
    guard let code = UserManager.shared.currentUser?.invitationCode else { return }
    
    if ShareApi.isKakaoTalkSharingAvailable() {
      // 카카오톡으로 카카오톡 공유 가능
      ShareApi.shared.shareCustom(templateId: templateId, templateArgs: ["userName":"\(userName)", "code":"\(code)"]) {(sharingResult, error) in
        if let error = error {
          print(error)
        }
        else {
          print("shareCustom() success.")
          if let sharingResult = sharingResult {
            UIApplication.shared.open(sharingResult.url, options: [:], completionHandler: nil)
          }
        }
      }
    }
    else {
      // 카카오톡 미설치: 웹 공유 사용 권장
      // Custom WebView 또는 디폴트 브라우져 사용 가능
      // 웹 공유 예시 코드
//      if let url = ShareApi.shared.makeCustomUrl(templateId: templateId, templateArgs:["title":"제목입니다.", "description":"설명입니다."]) {
//        self.safariViewController = SFSafariViewController(url: url)
//        self.safariViewController?.modalTransitionStyle = .crossDissolve
//        self.safariViewController?.modalPresentationStyle = .overCurrentContext
//        self.present(self.safariViewController!, animated: true) {
//          print("웹 present success")
//        }
//      }
    }
  }
}
