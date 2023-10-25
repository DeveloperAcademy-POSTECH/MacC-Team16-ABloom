//
//  SelectQuestionView.swift
//  ABloom
//
//  Created by yun on 10/23/23.
//
// MARK: 디자인 수정 예정!!
import SwiftUI

struct SelectQuestionView: View {
  @Environment(\.dismiss) private var dismiss
  
  @StateObject var questionVM = QuestionMainViewModel()
  
  var body: some View {
    VStack {
      ScrollView(.horizontal) {
        HStack(spacing: 16) {
          ForEach(Categories.allCases, id: \.self) { item in
            
            Text(item.rawValue)
              .fontWithTracking(.caption1R)
              .foregroundStyle(.stone700)
            
              .onTapGesture(perform: {
                print(item.hashValue)
              })
          }
        }
        .padding(.horizontal, 20)
      }
    }
    .customNavigationBar(
      centerView: {
        Text("질문 선택하기")
          .fontWithTracking(.title3R)
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
