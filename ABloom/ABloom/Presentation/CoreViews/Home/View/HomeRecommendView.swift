//
//  HomeRecommendView.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/19/23.
//

import SwiftUI

struct HomeRecommendView: View {
  let recommendQuestion: String
  let frameHeight: CGFloat = 98.0
  
  var body: some View {
    HStack(spacing: 16) {
      Image("TodayRecommendAsset")
        .resizable()
        .scaledToFit()
        .frame(width: 59, height: 59)
        .shadow(color: .black.opacity(0.08), radius: 11, x: 0, y: 8)
      
      VStack(alignment: .leading, spacing: 3) {
        Text("오늘의 추천 질문")
          .fontWithTracking(.subHeadlineBold)
          .foregroundStyle(.stone800)
        
        Text("\(recommendQuestion)")
          .lineLimit(2)
          .truncationMode(.tail)
          .foregroundStyle(.stone600)
          .multilineTextAlignment(.leading)
          .fontWithTracking(.footnoteR, tracking: -0.4, lineSpacing: 2)
      }
      
      Spacer()
    }
    .padding(.horizontal, 24)
    .background(
      Image("TodayRecommendBG")
        .resizable()
        .scaledToFill()
        .opacity(0.6)
        .frame(height: frameHeight)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    )
    .frame(height: frameHeight)
  }
}

#Preview {
  HomeRecommendView(recommendQuestion: "추천 질문입니다 추천질문입니다 추천질문입니다 추천질문입니다 추천질문입니다.")
}
