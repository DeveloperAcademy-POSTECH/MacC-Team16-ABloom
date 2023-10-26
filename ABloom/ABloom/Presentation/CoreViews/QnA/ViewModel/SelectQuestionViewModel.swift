//
//  SelectQuestionViewModel.swift
//  ABloom
//
//  Created by yun on 10/25/23.
//

import SwiftUI

class SelectQuestionViewModel: ObservableObject {
  @Published var selectedCategory: Category = Category.value
  
  func selectCategory(seleted: Category) {
    selectedCategory = seleted
  }
}
