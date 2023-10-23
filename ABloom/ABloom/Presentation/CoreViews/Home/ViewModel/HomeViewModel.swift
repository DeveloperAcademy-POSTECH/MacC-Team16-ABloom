//
//  HomeViewModel.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/19/23.
//

import SwiftUI

class HomeViewModel: ObservableObject {
  @Published var partnerName: String = "UserName"
  @Published var untilWeddingDate: Int = 0
  @Published var qnaCount: Int = 0
  @Published var isConnected: Bool = false
  @Published var partnerType: UserType = .woman
  @Published var recommendQuestion: String = "추천질문입니다"
}
