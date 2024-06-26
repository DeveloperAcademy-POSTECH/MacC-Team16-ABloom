//
//  AnswerManager.swift
//  ABloom
//
//  Created by 정승균 on 11/17/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

@MainActor
final class AnswerManager: ObservableObject {
  @Published var myAnswers: [DBAnswer]?
  @Published var fianceAnswers: [DBAnswer]?
  
  static let shared = AnswerManager()
  
  var myAnswersListener: ListenerRegistration?
  var fianceAnswersListener: ListenerRegistration?
  
  private let userCollection = Firestore.firestore().collection("users")
  
  private func userDocument(userId: String) -> DocumentReference {
    userCollection.document(userId)
  }
  
  private func userAnswerCollection(userId: String) -> CollectionReference {
    userDocument(userId: userId).collection("answers")
  }
  
  // MARK: Create
  func createAnswer(userId: String, questionId: Int, content: String) throws {
    let collection = userAnswerCollection(userId: userId)
    let document = collection.document()
    
    let data = DBAnswer(questionId: questionId, userId: userId, answerContent: content, isComplete: false, reaction: nil)
    
    try? document.setData(from: data, merge: false)
  }
  
  // MARK: Retrieve
  func addSnapshotListenerForMyAnswer() {
    guard let currentUserId = UserManager.shared.currentUser?.userId else { return }
    userAnswerCollection(userId: currentUserId).addSnapshotListener { querySnapshot, error in
      guard let document = querySnapshot?.documents else { return }
      
      self.myAnswers = document.compactMap { document in
        var answer = try? document.data(as: DBAnswer.self)
        answer?.answerId = document.documentID
        
        return answer
      }
    }
  }
  
  func addSnapshotListenerForFianceAnswer() {
    guard let fianceId = UserManager.shared.currentUser?.fiance else { return }
    
    userAnswerCollection(userId: fianceId).addSnapshotListener { querySnapshot, error in
      guard let document = querySnapshot?.documents else { return }
      
      self.fianceAnswers = document.compactMap { document in
        var answer = try? document.data(as: DBAnswer.self)
        answer?.answerId = document.documentID
        
        return answer
      }
    }
  }
  
  func fetchMyAnswers() async throws {
    guard let currentUserId = UserManager.shared.currentUser?.userId else { return }
    
    let collection = userAnswerCollection(userId: currentUserId)
    
    self.myAnswers = try await collection.getDocuments(as: DBAnswer.self)
  }
  
  func fetchFianceAnswers() async throws {
    guard let fianceId = UserManager.shared.currentUser?.fiance else { return }
    
    let collection = userAnswerCollection(userId: fianceId)
    let snapshot = try await collection.getDocuments()
    
    self.fianceAnswers = snapshot.documents.compactMap { document in
      var answer = try? document.data(as: DBAnswer.self)
      answer?.answerId = document.documentID
      
      return answer
    }
  }
  
  // MARK: Update Reaction & Completion
  func updateReactionNCompletion(userId: String, answerId: String, reaction: ReactionType?, isComplete: Bool) {
    var data: [String: Any] = [:]
    
    data[DBAnswer.CodingKeys.isComplete.rawValue] = isComplete
    
    if let reaction = reaction {
      data[DBAnswer.CodingKeys.reaction.rawValue] = reaction.rawValue
    }
    
    userAnswerCollection(userId: userId).document(answerId).updateData(data)
  }
  
  
  // MARK: Disconnect
  func disconnectListener() {
    self.myAnswersListener?.remove()
    self.fianceAnswersListener?.remove()
    self.myAnswers = []
    self.fianceAnswers = []
  }
}
