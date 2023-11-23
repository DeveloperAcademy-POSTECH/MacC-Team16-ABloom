//
//  OnboardingPageView.swift
//  ABloom
//
//  Created by yun on 11/18/23.
//

import SwiftUI

struct OnboardingPageView: View {
  let title: String
  let subtitle: String
  let imageName: String
  
  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      Text(title)
        .customFont(.title2R)
        .padding(.bottom, 3)
      
      Text(subtitle)
        .customFont(.title2B)
      
      Image(imageName)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 50)
    }
  }
}

#Preview {
  OnboardingPageView(
    title: "쓰기 탭",
    subtitle: "이 앱은 개인 메모장으로 쓸 수 있어요",
    imageName: "note.text.badge.plus"
  )
}
