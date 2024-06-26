//
//  AnnouncementManager.swift
//  ABloom
//
//  Created by Lee Jinhee on 6/22/24.
//

import FirebaseFirestore

final class AnnouncementManager {
  static let announcementCollection = Firestore.firestore().collection("announcements")
  
  static func fetchAnnouncement() async -> DBAnnouncement? {
    do {
      let documents = try await announcementCollection
        .order(by: "createdAt", descending: true)
        .limit(to: 1)
        .getDocuments()
        .documents
      
      guard let document = documents.first else { return nil }
      let announcement = try document.data(as: DBAnnouncement.self)
      return announcement
    } catch {
      return nil
    }
  }
}
