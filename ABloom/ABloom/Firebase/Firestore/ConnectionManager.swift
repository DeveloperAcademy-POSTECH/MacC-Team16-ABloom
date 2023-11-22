//
//  ConnectionManager.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/30/23.
//

import FirebaseFirestore

final class ConnectionManager {
  static let shared = ConnectionManager()
  @Published var isConnected: Bool = false
  
  private let userCollection = Firestore.firestore().collection("users")
  
  private func userDocument(userId: String) -> DocumentReference {
    userCollection.document(userId)
  }
  
  func fetchConnectionStatus() async throws {
    if let currentUserFiance = try await UserManager.shared.getCurrentUser().fiance {
      self.isConnected = !currentUserFiance.isEmpty
    }
  }
  
  func connectFiance(connectionCode: String) async throws {
    let snapshot = try await userCollection.whereField(DBUser.CodingKeys.invitationCode.rawValue, isEqualTo: connectionCode).getDocuments()
    
    /// 없는 코드에 접근한 경우
    guard let target = snapshot.documents.first else {
      throw ConnectionError.invalidConnectionCode
    }
    
    let targetUser = try target.data(as: DBUser.self)
    let targetUserId = targetUser.userId
    guard let currentUser = UserManager.shared.currentUser else {
      throw ConnectionError.notSignIn
    }
    
    /// 본인 아이디를 넣은 경우
    if currentUser.invitationCode == targetUser.invitationCode {
      throw ConnectionError.selfConnection
    }
    
    /// 상대방이 이미 연결되어 있는 경우
    if targetUser.fiance != nil {
      throw ConnectionError.fianceAlreadyExists
    }
    
    try await connectionUpdate(userId: currentUser.userId, targetId: targetUserId)
  }
  
  private func connectionUpdate(userId: String, targetId: String) async throws {
    try await self.userDocument(userId: targetId).updateData([DBUser.CodingKeys.fiance.rawValue: userId])
    try await self.userDocument(userId: userId).updateData([DBUser.CodingKeys.fiance.rawValue: targetId])
    
    self.isConnected = true
  }
}
