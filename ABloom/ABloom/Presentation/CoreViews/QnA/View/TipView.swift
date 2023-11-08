//
//  TipView.swift
//  ABloom
//
//  Created by Lee Jinhee on 11/8/23.
//

import SwiftUI

struct TipView: View {
  @Binding var isPresent: Bool

  private let title = "더 대화해보기"
  private let contentTitle1: String = "더 대화하고 알아보기"
  private let contentTitle2: String = "문답 완성하기"

  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Spacer()
        Text(title)
          .fontWithTracking(.subHeadlineBold, tracking: -0.4)
        Spacer()
        Button {
          isPresent = false
        } label: {
          Image(systemName: "xmark")
        }
        .padding(.trailing, -12)
      }
      .foregroundStyle(.stone600)
      .padding(.top, 20)
      .padding(.bottom, 14)
      .padding(.horizontal, 32)
      
      Rectangle().frame(height: 1.5)
        .foregroundStyle(.stone200)
      
      VStack(alignment: .leading, spacing: 2) {
        Text(contentTitle1)
          .fontWithTracking(.calloutBold, tracking: -0.4)
        
        Text("둘 중 한 명이라도")
        + Text(" ‘더 대화해보고 싶어요' ")
          .foregroundColor(.purple600)
        + Text("나")
        + Text(" ‘더 알아봐야겠어요' ")
          .foregroundColor(.purple600)
        + Text("를 선택한 경우, 함께 시간을 보내며 더 얘기를 나눠주세요.")
           
        Text(contentTitle2)
          .fontWithTracking(.calloutBold, tracking: -0.4)
          .padding(.top, 12)
        
        Text("함께 충분한 이야기를 나누고, 더 대화해보고 싶거나 알아보고 싶은 부분이 해결되었으면")
        + Text(" ‘문답 완성하기' ")
          .foregroundColor(.purple600)
        + Text("를 눌러 우리의 소중한 문답을 완성해주세요.")

      }
      .fontWithTracking(.subHeadlineR, tracking: -0.4, lineSpacing: 2)
      .foregroundStyle(.stone600)
      .padding(.vertical, 50)
      .padding(.horizontal, 32)
      
      Button {
        isPresent = false
      } label: {
        Text("확인")
          .fontWithTracking(.subHeadlineBold, tracking: -0.4)
          .padding(.vertical, 12)
          .frame(maxWidth: .infinity)
          .foregroundStyle(.white)
          .background(Color.purple500)
          .cornerRadius(12, corners: .allCorners)
      }
      .padding(.horizontal, 32)
      .padding(.bottom, 18)
    }
    .frame(height: 400)
    .background(Color.stone100)
    .cornerRadius(16, corners: .allCorners)
    .padding(.horizontal, 8)
  }
}

#Preview {
  TipView(isPresent: .constant(true))
}
