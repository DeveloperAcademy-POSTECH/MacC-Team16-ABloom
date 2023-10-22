//
//  UserManager.swift
//  ABloom
//
//  Created by 정승균 on 10/21/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

/// DB에 저장될 User Model
struct DBUser: Codable {
  let userId: String
  let name: String
  let sex: Bool
  let estimatedMarriageDate: Date
}

final class UserManager {
  static let shared = UserManager()
  
  private let userCollection = Firestore.firestore().collection("users")
  
  private func userDocument(userId: String) -> DocumentReference {
    userCollection.document(userId)
  }
  
  // MARK: GET Method
  func getUser(userId: String) async throws -> DBUser {
    try await userDocument(userId: userId).getDocument(as: DBUser.self)
  }
  
  
  // MARK: POST Method
  func createUser(user: DBUser) throws {
    try userDocument(userId: user.userId).setData(from: user, merge: false)
  }
}
