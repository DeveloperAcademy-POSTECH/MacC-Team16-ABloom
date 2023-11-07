//
//  AnswerBackShape.swift
//  ABloom
//
//  Created by yun on 10/23/23.
//

import SwiftUI

struct CategoryQuestionBox: View {
  let question: String
  
  var body: some View {
    HStack(alignment: .top, spacing: 9) {
      
      Image("noticeIcon")
        .resizable()
        .frame(width: 22, height: 22)
      
      Text("\(question)")
        .fontWithTracking(.subHeadlineR, lineSpacing: 3)
        .multilineTextAlignment(.leading)
      
      Spacer()
    }
    .padding(.horizontal, 14)
    .padding(.vertical, 10)

    .background(
      RoundedRectangle(cornerRadius: 20)
        .foregroundStyle(.stone50)
    )
    .frame(maxWidth: .infinity)
  }
}

#Preview {
  CategoryQuestionBox(question: "반려동물을 기르고 싶어?")
}
