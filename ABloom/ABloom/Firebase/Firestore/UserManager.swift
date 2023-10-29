//
//  UserManager.swift
//  ABloom
//
//  Created by 정승균 on 10/21/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

/// DB에 저장될 User Model
struct DBUser: Codable {
  let userId: String
  let name: String?
  let sex: Bool?
  let estimatedMarriageDate: Date?
  let invitationCode: String?
  let fiance: String?
  
  init(userId: String, name: String, sex: Bool, estimatedMarriageDate: Date, invitationCode: String, fiance: String? = nil) {
    self.userId = userId
    self.name = name
    self.sex = sex
    self.estimatedMarriageDate = estimatedMarriageDate
    self.invitationCode = invitationCode
    self.fiance = fiance
  }
  
  init(auth: AuthDataResultModel) {
    self.userId = auth.uid
    self.name = auth.name
    self.sex = nil
    self.estimatedMarriageDate = nil
    self.invitationCode = nil
    self.fiance = nil
  }
  
  enum CodingKeys: String, CodingKey {
    case userId = "user_id"
    case name = "name"
    case sex = "sex"
    case estimatedMarriageDate = "estimated_marriage_date"
    case invitationCode = "invitation_code"
    case fiance = "fiance"
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.userId, forKey: .userId)
    try container.encode(self.name, forKey: .name)
    try container.encode(self.sex, forKey: .sex)
    try container.encode(self.estimatedMarriageDate, forKey: .estimatedMarriageDate)
    try container.encode(self.invitationCode, forKey: .invitationCode)
    try container.encode(self.fiance, forKey: .fiance)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.userId = try container.decode(String.self, forKey: .userId)
    self.name = try container.decode(String.self, forKey: .name)
    self.sex = try container.decode(Bool.self, forKey: .sex)
    self.estimatedMarriageDate = try container.decode(Date.self, forKey: .estimatedMarriageDate)
    self.invitationCode = try container.decode(String.self, forKey: .invitationCode)
    self.fiance = try container.decodeIfPresent(String.self, forKey: .fiance)
  }
}

final class UserManager {
  static let shared = UserManager()
  
  private let userCollection = Firestore.firestore().collection("users")
  
  private func userDocument(userId: String) -> DocumentReference {
    userCollection.document(userId)
  }
  
  // MARK: GET Method
  func getCurrentUser() async throws -> DBUser {
    let currentUser = try AuthenticationManager.shared.getAuthenticatedUser()
    
    return try await getUser(userId: currentUser.uid)
  }
  
  func getUser(userId: String) async throws -> DBUser {
    try await userDocument(userId: userId).getDocument(as: DBUser.self)
  }
  
  
  // MARK: POST Method
  func createNewUser(user: DBUser) throws {
    try userDocument(userId: user.userId).setData(from: user, merge: false)
  }
  
  func updateUserName(userId: String, name: String) throws {
    let data: [String:Any] = [DBUser.CodingKeys.name.rawValue : name]
    userDocument(userId: userId).updateData(data)
  }
  
  func connectFiance(connectionCode: String) async throws {
    let snapshot = try await userCollection.whereField(DBUser.CodingKeys.invitationCode.rawValue, isEqualTo: connectionCode).getDocuments()
    
    guard let target = snapshot.documents.first else {
      throw URLError(.badServerResponse)
    }
    
    // TODO: 에러처리
    // 1. 상대방이 이미 연결되어 있는 경우
    // 2. 없는 코드에 접근한 경우
    let targetId = try target.data(as: DBUser.self).userId
    let myId = try AuthenticationManager.shared.getAuthenticatedUser().uid
    
    try await userDocument(userId: targetId).updateData([DBUser.CodingKeys.fiance.rawValue:myId])
    try await userDocument(userId: myId).updateData([DBUser.CodingKeys.fiance.rawValue:targetId])
  }
}
