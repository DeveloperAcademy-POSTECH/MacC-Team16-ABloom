//
//  ABloom
//
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

/// DB에 저장된 Static Quesiton
struct DBStaticQuestion: Codable, Hashable {
  let questionID: Int
  let category: String
  let content: String
  
  init(questionID: Int, category: String, content: String) {
    self.questionID = questionID
    self.category = category
    self.content = content
  }
  
  enum CodingKeys: String, CodingKey {
    case questionID = "q_id"
    case category = "category"
    case content = "content"
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.questionID, forKey: .questionID)
    try container.encode(self.category, forKey: .category)
    try container.encode(self.content, forKey: .content)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.questionID = try container.decode(Int.self, forKey: .questionID)
    self.category = try container.decode(String.self, forKey: .category)
    self.content = try container.decode(String.self, forKey: .content)
  }
}

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
    let myAnswers = try await UserManager.shared.getMyAnswers(userId: userId)
    
    return myAnswers.map { answer in answer.questionId }
  }
  
  func getAnswerdQuestions(questionIds: [Int]) async throws -> [DBStaticQuestion] {
    return try await questionCollection
      .whereField(DBStaticQuestion.CodingKeys.questionID.rawValue, in: questionIds)
      .getDocuments(as: DBStaticQuestion.self)
  }
}
