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
      
      questionListView
        .navigationDestination(for: DBStaticQuestion.self, destination: { content in
          AnswerWriteView(question: content)
        })
        .background(backWall())
    }
    
    .task {
      try? await selectQVM.fetchQuestions()
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
    
    .background(backgroundDefault())
    .ignoresSafeArea(.all, edges: .bottom)
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
      .padding([.horizontal, .bottom], 22)
      .padding(.top, 36)
      
    }
  }
  
  private var questionListView: some View {
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
      
      ScrollView(.vertical) {
        ForEach(selectQVM.filteredLists, id: \.self) { question in
          NavigationLink(value: question) {
            LeftBlueChatBubble(text: question.content)
          }
          .padding(.horizontal, 20)
          .padding(.bottom, 12)
        }
      }
    }
  }
}

#Preview {
  SelectQuestionView()
}
