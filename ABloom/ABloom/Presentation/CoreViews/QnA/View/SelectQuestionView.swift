//
//  SelectQuestionView.swift
//  ABloom
//
//  Created by yun on 10/23/23.
//

import SwiftUI

struct SelectQuestionView: View {
  @Environment(\.dismiss) private var dismiss
  
  @StateObject var selectQVM = SelectQuestionViewModel()
  
  var body: some View {
    VStack {
      
      categoryBar
      
      VStack(spacing: 0) {
        HStack {
          Text("\(selectQVM.selectedCategory.type) 문답")
            .fontWithTracking(.headlineR)
            .foregroundStyle(.stone700)
          
          Spacer()
        }
        .padding(.horizontal, 22)
        .padding(.top, 34)
        .padding(.bottom, 26)
        
        
        ScrollView {
          ForEach(12..<20) { num in
            // TODO: 데이터 작업 필요
            NavigationLink(value: Color.accentColor) {
              LeftBlueChatBubble(text: "나와 결혼을 결심한 순간은 언제야?\(num)")
                .padding(.bottom, 12)
                .padding(.horizontal, 20)
            }
          }
        }
        Spacer()
      }
      // 네비게이션
      .navigationDestination(for: Color.self, destination: { content in
        // TODO: 차후 구현
        AnswerWriteView()
      })
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(backWall())
    }
    
    // 네비게이션바
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

extension SelectQuestionView {
  
  private var categoryBar: some View {
    
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 16) {
        ForEach(Category.allCases, id: \.self) { category in
          VStack(alignment: .center, spacing: 6) {
            Image(category.imgName)
              .resizable()
              .frame(width: 64, height: 64)
            Text(category.type)
              .fontWithTracking(selectQVM.selectedCategory == category ? .caption1Bold : .caption1R)
              .foregroundStyle(.stone700)
          }
          .opacity(selectQVM.selectedCategory == category ? 1 : 0.4)
          .onTapGesture(perform: {
            selectQVM.selectCategory(seleted: category)
          })
        }
      }
      .padding(.horizontal, 22)
      .padding(.bottom, 15)
    }
  }
}

#Preview {
  SelectQuestionView()
}
