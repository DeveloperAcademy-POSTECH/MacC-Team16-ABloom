//
//  UserManager.swift
//  ABloom
//
//  Created by 정승균 on 10/21/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class UserManager {
  static let shared = UserManager()
  
  // MARK: 사용 객체
  private let userCollection = Firestore.firestore().collection("users")
  
  private func userDocument(userId: String) -> DocumentReference {
    userCollection.document(userId)
  }
  
  private func userAnswerCollection(userId: String) -> CollectionReference {
    userDocument(userId: userId).collection("answers")
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
    let data: [String: Any] = [DBUser.CodingKeys.name.rawValue:name]
    userDocument(userId: userId).updateData(data)
  }
  
  func updateMarriageDate(userId: String, date: Date) throws {
    let data: [String: Any] = [DBUser.CodingKeys.marriageDate.rawValue:date]
    userDocument(userId: userId).updateData(data)
  }
  
  // MARK: Answer
  func creatAnswer(userId: String, questionId: Int, content: String) throws {
    let collection = userAnswerCollection(userId: userId)
    let document = collection.document()
    
    let data = DBAnswer(questionId: questionId, userId: userId, answerContent: content)
    
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
  
  func getAnswer(userId: String, questionId: Int) async throws -> DBAnswer {
    let collection = userAnswerCollection(userId: userId)
    let userAnswer = try await collection
      .whereField(DBAnswer.CodingKeys.questionId.rawValue, isEqualTo: questionId)
      .getDocuments(as: DBAnswer.self)
    
    guard let answer = userAnswer.first else { throw URLError(.badServerResponse)}
    
    return answer
  }
}
