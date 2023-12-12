//
//  MixpanelManager.swift
//  ABloom
//
//  Created by 정승균 on 12/12/23.
//

import Foundation
import Mixpanel

class MixpanelManager {
  static private var instance = Mixpanel.mainInstance()
  
  static func example() {
    instance.track(event: "Signed Up", properties: ["Signup Type": "Referral"])
  }

}

// MARK: Track SignUp event
extension MixpanelManager {
  static func signUpStart(pageNum: Int) {
    let properties: [String: String] = ["onboardingPage":"\(pageNum + 1)"]
    
    instance.track(event: "signup_start", properties: properties)
    print("track")
  }
  
  static func signUpSocial(type: String) {
    let properties: [String: String] = ["socialLogin":type]
    
    instance.people.set(properties: properties)
    instance.track(event: "signup_social", properties: properties)
  }
  
  static func setIdentify(id: String) {
    instance.identify(distinctId: id)
  }
  
  static func signUpSexType(type: UserSexType) {
    let properties = ["sex":type.rawValue]
    
    instance.track(event: "signup_sex_type", properties: properties)
    instance.people.set(properties: properties)
  }
  
  static func signUpDate(date: Date) {
    let properties = ["marriageDate": date.formatToYMD()]
    
    instance.track(event: "signup_date", properties: properties)
    instance.people.set(properties: properties)
  }
  
  static func signUpName(name: String) {
    let properties = ["name": name]
    
    instance.track(event: "signup_name", properties: properties)
    instance.people.set(properties: properties)
  }
  
  static func signUpCompelete() {
    instance.track(event: "signup_complete")
  }
}

extension MixpanelManager {
  static func signIn(type: String) {
    let properties = ["socialLogin": type]
    
    instance.track(event: "signin_complete", properties: properties)
  }
}
