//
//  ABloom
//
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class StaticQuestionManager {
  static let shared = StaticQuestionManager()
  
  private let questionCollection = Firestore.firestore().collection("questions")
  
  // MARK: GET Method
  func getQuestionsWithoutAnswers(myId: String, fianceId: String?) async throws -> [DBStaticQuestion] {
    var ids = try await getAnswersId(userId: myId)
    
    if let fianceId = fianceId {
      ids += try await getAnswersId(userId: fianceId)
    }
    
    var allQuestions = try await questionCollection.getDocuments(as: DBStaticQuestion.self)
    
    allQuestions.removeAll { question in
      for id in ids {
        if id == question.questionID {
          return true
        }
      }
      return false
    }
    
    return allQuestions
  }
  
  private func getAnswersId(userId: String) async throws -> [Int] {
    let myAnswers = try await UserManager.shared.getAnswers(userId: userId)
    
    return myAnswers.map { answer in answer.questionId }
  }
  
  func getAnsweredQuestions(questionIds: [Int]) async throws -> [DBStaticQuestion] {
    try await questionCollection
//      .whereField(DBStaticQuestion.CodingKeys.questionID.rawValue, in: questionIds)
      .getDocuments(as: DBStaticQuestion.self)
  }
  
  func getQuestionById(id: Int) async throws -> DBStaticQuestion {
    try await questionCollection.document("\(id)").getDocument(as: DBStaticQuestion.self)
  }
}
