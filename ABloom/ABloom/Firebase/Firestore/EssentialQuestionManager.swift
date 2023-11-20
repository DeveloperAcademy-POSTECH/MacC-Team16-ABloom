//
//  EssentialQuestionManager.swift
//  ABloom
//
//  Created by 정승균 on 11/17/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class EssentialQuestionManager: ObservableObject {
  static var shared = EssentialQuestionManager()
  
  @Published var essentialQuestions: [Int]?
  @Published var randomQuestions: [Int]?
  
  private let essentialCollection = Firestore.firestore().collection("essentialQuestions")
  
  // MARK: Retrieve
  func fetchEssentialCollections() async throws {
    let document = try await essentialCollection.document("essentialQuestionsId").getDocument(as: DBEssentialQuestion.self)
    self.essentialQuestions = document.fixedOrder
    self.randomQuestions = document.randomOrder
  }
  
}
