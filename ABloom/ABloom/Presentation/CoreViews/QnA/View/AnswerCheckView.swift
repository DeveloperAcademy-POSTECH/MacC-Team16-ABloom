//
//  AnswerView.swift
//  ABloom
//
//  Created by yun on 10/22/23.
//

import SwiftUI

struct AnswerCheckView: View {
  @Environment(\.dismiss) private var dismiss
  let num: Int
  var body: some View {
    VStack {
      Text("Hello, World!\(num)")
    }
    .customNavigationBar(
      centerView: {
        Text("우리의 문답")
          .fontWithTracking(fontStyle: .title3R)
          .foregroundStyle(.stone700)
      },
      leftView: {
        Button(action: {dismiss()}, label: {
          Image("angle-left")
            .frame(width: 20, height: 20)
        })
      },
      rightView: {
        EmptyView()
      })
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(backgroundDefault())
  }
}

#Preview {
  AnswerCheckView(num: 1)
}
