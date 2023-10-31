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
        .frame(height: 118)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 32))
       
      HStack(spacing: 16) {
        Image(systemName: "")
          .resizable()
          .scaledToFit()
          .foregroundStyle(.pink100)
          .frame(width: 59, height: 59)
          .background(.stone200)
        VStack(alignment: .leading, spacing: 6) {
          Text("오늘의 추천 질문")
            .fontWithTracking(fontStyle: .subHeadlineBold)
            .foregroundStyle(.stone800)
          Text("\"\(recommendQuestion)\"")
            .fontWithTracking(fontStyle: .footnoteBold, value: -0.4)
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
