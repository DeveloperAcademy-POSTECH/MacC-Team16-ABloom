//
//  ABloom
//
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

@MainActor
final class StaticQuestionManager {
  static let shared = StaticQuestionManager()
  
  @Published var staticQuestions: [DBStaticQuestion]?
  @Published var filteredQuestions: [DBStaticQuestion]?
  
  @Published var myAnswers: [DBAnswer]?
  @Published var fianceAnswers: [DBAnswer]?
  
  private let questionCollection = Firestore.firestore().collection("questions")
  private let essentialCollection = Firestore.firestore().collection("essentialQuestions")
  
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: Retrieve
  func fetchStaticQuestions() async throws {
    self.staticQuestions = try await questionCollection.getDocuments(as: DBStaticQuestion.self)
  }
  
  func fetchFilterQuestions() {
    
    AnswerManager.shared.$myAnswers
      .sink { [weak self] myAnswers in
        if let myAns = myAnswers {
          self?.myAnswers = myAns
          self?.filterApply()
        }
      }
      .store(in: &cancellables)
    
    AnswerManager.shared.$fianceAnswers
      .sink { [weak self] fianceAnswers in
        if let fianceAns = fianceAnswers {
          self?.fianceAnswers = fianceAns
          self?.filterApply()
        }
      }
      .store(in: &cancellables)
  }
  
  private func filterApply() {
    
    var ids: [Int] = []
    
    if let myAnswers = self.myAnswers {
      ids += myAnswers.map { $0.questionId }
    }
    if let fianceAnswers = self.fianceAnswers {
      ids += fianceAnswers.map { $0.questionId }
    }
    
    self.filteredQuestions = self.staticQuestions?.filter({ question in
      !ids.contains { id in
        id == question.questionID
      }
    })
  }
  
  
  // MARK: essentialQ id로 question 가지고 올 때 사용
  func getQuestionById(id: Int) async throws -> DBStaticQuestion {
    try await questionCollection.document("\(id)").getDocument(as: DBStaticQuestion.self)
  }
  
  
  // MARK: Will be deprecated properties
  @Published var essentialQuestionsOrder = [Int]()
  @Published var essentialQuestionsRandom = [Int]()
  
  // MARK: Will be deprecated method
  // MARK: GET Method
  func getQuestionsWithoutAnswers(myId: String, fianceId: String?) async throws -> [DBStaticQuestion] {
    var ids = try await getAnswersId(userId: myId)
    
    if let fianceId = fianceId {
      ids += try await getAnswersId(userId: fianceId)
    }
    
    var allQuestions = try await questionCollection.order(by: "q_id").getDocuments(as: DBStaticQuestion.self)
    
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
    if questionIds.isEmpty {
      return []
    }
    return try await questionCollection
      .whereField(DBStaticQuestion.CodingKeys.questionID.rawValue, in: questionIds)
      .getDocuments(as: DBStaticQuestion.self)
  }
}
