//
//  SelectQuestionView.swift
//  ABloom
//
//  Created by yun on 10/23/23.
//

import SwiftUI

struct SelectQuestionView: View {
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    VStack {
      Text("This is Selection View")
    }
    .customNavigationBar(
      centerView: {
        Text("질문 선택하기")
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
  SelectQuestionView()
}
