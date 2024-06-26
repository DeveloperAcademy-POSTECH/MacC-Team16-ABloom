//
//  DBAnnouncementModel.swift
//  ABloom
//
//  Created by Lee Jinhee on 6/22/24.
//

import Foundation

struct DBAnnouncement: Decodable, Hashable {
  let createdAt: Date
  let title: String
  let url: String
}
