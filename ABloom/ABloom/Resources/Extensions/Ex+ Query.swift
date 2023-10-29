//
//  Ex+ Query.swift
//  ABloom
//
//  Created by 정승균 on 10/29/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

extension Query {
  /// 한 번에 많은 도큐먼트를 불러올 수 있도록 하는 함수
  func getDocuments<T>(as type: T.Type) async throws -> [T] where T: Decodable {
    // query snapshot
    let snapshot = try await self.getDocuments()
    
    // 2. 고급 함수를 이용하여 구현하기
    return try snapshot.documents.map { document in
      return try document.data(as: T.self)
    }
  }
}
