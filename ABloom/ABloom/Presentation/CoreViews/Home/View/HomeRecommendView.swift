//
//  HomeRecommendView.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/19/23.
//

import SwiftUI

struct HomeRecommendView: View {
  let recommendQuestion: String
  
  var body: some View {
    ZStack {
      Image("TodayRecommendBG")
        .resizable()
        .frame(height: 98)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 16))
       
      HStack(spacing: 16) {
        Image(systemName: "")
          .resizable()
          .scaledToFit()
          .foregroundStyle(.pink100)
          .frame(width: 59, height: 59)
          .clipShape(RoundedRectangle(cornerRadius: 12))
          .background(.stone200)
        VStack(alignment: .leading, spacing: 6) {
          Text("오늘의 추천 질문")
            .fontWithTracking(.subHeadlineBold)
            .foregroundStyle(.stone800)
          Text("\"\(recommendQuestion)\"")
            .fontWithTracking(.footnoteR, tracking: -0.4)
            .foregroundStyle(.stone600)
        }
        Spacer()
      }
      .padding(.horizontal, 24)
    }
  }
}

#Preview {
  HomeRecommendView(recommendQuestion: "추천질문입니다.")
}
