//
//  UserManager.swift
//  ABloom
//
//  Created by 정승균 on 10/21/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

@MainActor
final class UserManager: ObservableObject {
  static let shared = UserManager()
  
  private var listener: ListenerRegistration?
  @Published var currentUser: DBUser?
  @Published var fianceUser: DBUser?
  
  // MARK: 사용 객체
  private let userCollection = Firestore.firestore().collection("users")
  
  private func userDocument(userId: String) -> DocumentReference {
    userCollection.document(userId)
  }
  
  private func userAnswerCollection(userId: String) -> CollectionReference {
    userDocument(userId: userId).collection("answers")
  }
  
  // MARK: Create
  func createUser(user: DBUser) throws {
    try userDocument(userId: user.userId).setData(from: user, merge: false)
    Task {
      try? await fetchCurrentUser()
      AnswerManager.shared.addSnapshotListenerForMyAnswer()
      AnswerManager.shared.addSnapshotListenerForFianceAnswer()
    }
  }
  
  
  // MARK: Retrieve
  func fetchCurrentUser() async throws {
    // TODO: 에러처리
    do {
      let currentUser = try AuthenticationManager.shared.getAuthenticatedUser()
      self.currentUser = try await getUser(userId: currentUser.uid)
    } catch {
      self.currentUser = nil
    }
  }
  
  func fetchFianceUser() async throws {
    guard let fianceId = self.currentUser?.fiance else {
      self.fianceUser = nil
      self.addSnapshotListenerForFiance()
      return
    }
    
    self.fianceUser = try await getUser(userId: fianceId)
  }
  
  // TODO: private로 수정
  func getUser(userId: String) async throws -> DBUser {
    try await userDocument(userId: userId).getDocument(as: DBUser.self)
  }
  
  // MARK: Update
  // TODO: 유저 아이디를 받지 않고 수정이 가능하도록 구현
  func updateUserName(userId: String, name: String) throws {
    let data: [String: Any] = [DBUser.CodingKeys.name.rawValue:name]
    userDocument(userId: userId).updateData(data)
    
    Task {
      try? await fetchCurrentUser()
    }
  }
  
  func updateMarriageDate(userId: String, date: Date) throws {
    let data: [String: Any] = [DBUser.CodingKeys.marriageDate.rawValue:date]
    userDocument(userId: userId).updateData(data)
    Task {
      try? await fetchCurrentUser()
    }
  }
  
  func updateFcmToken(userID: String, fcmToken: String) throws {
    let fcmToken: [String: Any] = [DBUser.CodingKeys.fcmToken.rawValue:fcmToken]
    userDocument(userId: userID).updateData(fcmToken)
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
    try await fetchCurrentUser()
    try await fetchFianceUser()
    AnswerManager.shared.addSnapshotListenerForMyAnswer()
    AnswerManager.shared.addSnapshotListenerForFianceAnswer()
  }
  
  private func connectionUpdate(userId: String, targetId: String) async throws {
    try await self.userDocument(userId: targetId).updateData([DBUser.CodingKeys.fiance.rawValue: userId])
    try await self.userDocument(userId: userId).updateData([DBUser.CodingKeys.fiance.rawValue: targetId])
  }
  
  // MARK: Delete
  
  func deleteUser() async throws {
    let user = try await UserManager.shared.getCurrentUser()
    
    try await deleteSubCollection(userId: user.userId)
    try await userDocument(userId: user.userId).delete()
    
    guard let fiance = user.fiance else { throw URLError(.badURL)}
    
    let data: [String: Any?] = [DBUser.CodingKeys.fiance.rawValue: nil]
    try await userDocument(userId: fiance).updateData(data as [AnyHashable: Any])
  }
  
  private func deleteSubCollection(userId: String) async throws {
    let documents = try await userAnswerCollection(userId: userId).getDocuments().documents
    
    for document in documents {
      try await document.reference.delete()
    }
  }
  
  func addSnapshotListenerForFiance() {
    guard let userId = UserManager.shared.currentUser?.userId else { return }
    
    listener = userDocument(userId: userId).addSnapshotListener { [weak self] (snapShot, error) in
      guard let data = try? snapShot?.data(as: DBUser.self), let fiance = data.fiance else { return }
      if !fiance.isEmpty {
        self?.updateUserStatus()
        self?.removeSnapshotListener()
      }
    }
  }
  
  func updateUserStatus() {
    Task {
      try? await fetchCurrentUser()
      try? await fetchFianceUser()
      
      StaticQuestionManager.shared.fetchFilterQuestions()
      AnswerManager.shared.addSnapshotListenerForFianceAnswer()
    }
  }
  
  func removeSnapshotListener() {
    listener?.remove()
    listener = nil
  }

  // MARK: Will be deprecated method
  // MARK: GET Method
  func getCurrentUser() async throws -> DBUser {
    let currentUser = try AuthenticationManager.shared.getAuthenticatedUser()
    
    return try await getUser(userId: currentUser.uid)
  }
  
  
  // MARK: POST Method

  
  // MARK: Answer
  func creatAnswer(userId: String, questionId: Int, content: String) throws {
    let collection = userAnswerCollection(userId: userId)
    let document = collection.document()
    
    let data = DBAnswer(questionId: questionId, userId: userId, answerContent: content, isComplete: false, reaction: nil)
    
    try? document.setData(from: data, merge: false)
  }
  
  func getAnswers(userId: String) async throws -> [DBAnswer] {
    let collection = userAnswerCollection(userId: userId)
    return try await collection.getDocuments(as: DBAnswer.self)
  }
  
  func getAnswerWithId(userId: String, filter: [Any]) async throws -> [DBAnswer] {
    let collection = userAnswerCollection(userId: userId)
    
    if filter.isEmpty {
      return []
    } else {
      return try await collection
        .whereField(DBAnswer.CodingKeys.questionId.rawValue, in: filter)
        .getDocuments(as: DBAnswer.self)
    }
  }
  
  func getAnswer(userId: String, questionId: Int) async throws -> (answer: DBAnswer, answerId: String) {
    let collection = userAnswerCollection(userId: userId)
    let userAnswerSnapshot = try await collection
      .whereField(DBAnswer.CodingKeys.questionId.rawValue, isEqualTo: questionId)
      .getDocuments()
    
    guard let answerDocumentSnapshot = userAnswerSnapshot.documents.first else { throw URLError(.badServerResponse) }
    
    let answer = try answerDocumentSnapshot.data(as: DBAnswer.self)
    
    return (answer, answerId: answerDocumentSnapshot.documentID)
  }
  
  func updateReaction(userId: String, answerId: String, reaction: ReactionType) {
    let data: [String: Any] = [DBAnswer.CodingKeys.reaction.rawValue:reaction.rawValue]
    
    userAnswerCollection(userId: userId).document(answerId).updateData(data)
  }
  
//  func updateAnswerComplete(userId: String, answerId: String) {
//    let data: [String: Any] = [DBAnswer.CodingKeys.isComplete.rawValue:true]
//    
//    userAnswerCollection(userId: userId).document(answerId).updateData(data)
//  }
}
