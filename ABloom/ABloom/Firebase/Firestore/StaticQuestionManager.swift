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
}
