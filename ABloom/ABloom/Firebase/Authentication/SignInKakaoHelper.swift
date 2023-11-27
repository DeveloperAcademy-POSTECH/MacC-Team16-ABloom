//
//  SignInKakaoHelper.swift
//  ABloom
//
//  Created by Lee Jinhee on 11/25/23.
//

import FirebaseAuth
import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import SwiftUI

final class SignInKakaoHelper: NSObject {
  var currentEmail: String?
  var currentId: String?

  func openKakaoService(withCompletionHandler completionHandler: @escaping () -> Void) {
    if UserApi.isKakaoTalkLoginAvailable() { // 카카오톡 앱 이용 가능한지
      UserApi.shared.loginWithKakaoTalk { oAuthToken, error in // 카카오톡 앱으로 로그인
        if let error = error { // 로그인 실패 -> 종료
          print("Kakao Sign In Error: \(error.localizedDescription)")
          return
        }
       
        // 사용자 정보 불러와서 Firebase Auth 로그인하기
        self.loadingInfoDidKakaoAuth {
          completionHandler()
        }
      }
    } else {
      UserApi.shared.loginWithKakaoAccount { oAuthToken, error in // 카카오톡 계정으로 로그인
        if let error = error { // 로그인 실패 > 종료
          print("Kakao Sign In Error: \(error.localizedDescription)")
          return
        }
       
        self.loadingInfoDidKakaoAuth {
          completionHandler()
        }
      }
    }
  }
  
  func loadingInfoDidKakaoAuth(withCompletionHandler completionHandler: @escaping () -> Void) {
    UserApi.shared.me { kakaoUser, error in
      if let _ = error {
        print("카카오톡 사용자 정보 불러오는데 실패했습니다.")
        return
      }
      guard let email = kakaoUser?.kakaoAccount?.email else { return }
      guard let password = kakaoUser?.id else { return }

      self.currentEmail = email
      self.currentId = String(password)

      completionHandler()
    }
  }
  
  func kakaoSignOut() {
    UserApi.shared.logout {(error) in
      if let error = error {
        print(error.localizedDescription)
      }
      else {
        print("Kakao logout success.")
      }
    }
  }
}
