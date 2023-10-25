//
//  AnswerBackShape.swift
//  ABloom
//
//  Created by yun on 10/23/23.
//

import SwiftUI

struct CategoryQuestionBox: View {
  let question: String
  let category: String
  let categoryImg: String
  
  var body: some View {
    VStack(alignment: .center, spacing: 17) {
      HStack(spacing: 17) {
        Spacer()
        Image(categoryImg)
          .resizable()
          .frame(width: 28, height: 28)
        Text(category)
          .fontWithTracking(.subHeadlineBold)
        Spacer()
      }
      .padding(.top, 25)
      
      Text("\"\(question)\"")
        .fontWithTracking(.subHeadlineR)
        .padding(.bottom, 22)
    }
    .frame(maxWidth: .infinity)
    .frame(height: 104)
    .background(
      RoundedRectangle(cornerRadius: 20)
        .foregroundStyle(.white)
    )
    .padding(.horizontal, 20)
  }
}

#Preview {
  CategoryQuestionBox(question: "반려동물을 기르고 싶어?", category: "경제 질문", categoryImg: "squareIcon_isometric_health")
}
