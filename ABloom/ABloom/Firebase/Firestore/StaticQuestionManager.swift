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
  func getAllQuestions(userId: String) async throws -> [DBStaticQuestion] {
    // 내가 이미 작성한 문항은 제외하고 GET
    let ids = try await getMyAnswersId(userId: userId)
    return try await  questionCollection
      .whereField(DBStaticQuestion.CodingKeys.questionID.rawValue, notIn: ids)
      .getDocuments(as: DBStaticQuestion.self)
  }
  
  func getMyAnswersId(userId: String) async throws -> [Int] {
    let myAnswers = try await UserManager.shared.getAnswers(userId: userId)
    
    return myAnswers.map { answer in answer.questionId }
  }
  
  func getAnswerdQuestions(questionIds: [Int]) async throws -> [DBStaticQuestion] {
    try await questionCollection
      .whereField(DBStaticQuestion.CodingKeys.questionID.rawValue, in: questionIds)
      .getDocuments(as: DBStaticQuestion.self)
  }
  
  func getQuestionById(id: Int) async throws -> DBStaticQuestion {
    try await questionCollection.document("\(id)").getDocument(as: DBStaticQuestion.self)
  }
}
