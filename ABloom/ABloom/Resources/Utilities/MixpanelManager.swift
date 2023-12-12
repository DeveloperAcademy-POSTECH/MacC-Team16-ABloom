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

// MARK: Track SignIn event
extension MixpanelManager {
  static func signIn(type: String) {
    let properties = ["socialLogin": type]
    
    instance.track(event: "signin_complete", properties: properties)
  }
}

// MARK: Track Answer event
extension MixpanelManager {
  static func qnaGenerate() {
    instance.track(event: "qna_generate")
  }
  
  static func qnaCategory(category: String) {
    let properties = ["category": category]
    
    instance.track(event: "qna_category", properties: properties)
  }
  
  static func qnaSelectQuestion(questionId: Int) {
    let properties = ["questionId": "\(questionId)"]
    
    instance.track(event: "qna_select_question", properties: properties)
  }
  
  static func qnaAnswer(letterCount: Int) {
    let eventProperties = ["letterCount": "\(letterCount)"]
    
    instance.people.increment(property: "answeredQuestion", by: 1)
    instance.track(event: "qna_answer", properties: eventProperties)
  }
  
  static func qnaReaction(type: String) {
    let properties = ["reactionType": "\(type)"]
    
    instance.track(event: "qna_reaction", properties: properties)
  }
}
