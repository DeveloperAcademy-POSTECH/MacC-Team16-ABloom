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
    VStack(alignment: .center) {
      Text(title)
        .customFont(.title2R)
        .padding(.bottom, 3)
      
      Text(subtitle)
        .customFont(.title2B)
      
      // TODO: 오류방지를 위해 시스템이미지로 임의진행
      Image(systemName: imageName)
        .customFont(.bodyB)
        .frame(maxHeight: .infinity)
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
