//
//  SelectQuestionView.swift
//  ABloom
//
//

import SwiftUI

struct SelectQuestionView: View {
  @StateObject var selectQVM = SelectQuestionViewModel()
  
  var body: some View {
    VStack(spacing: 0) {
      
      categoryBar
      bottomGradient
      
      
      questionListView
    }
    .task {
      selectQVM.fetchQuestions()
    }
    .sheet(isPresented: $selectQVM.isAnswerSheetOn,
           content: {
      
    })
  }
}

extension SelectQuestionView {
  
  private var categoryBar: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 50) {
        
        ForEach(Category.allCases, id: \.self) { category in
          VStack(alignment: .center, spacing: 0) {
            
            Image(category.rawValue)
              .resizable()
              .renderingMode(.template)
              .frame(width: 24, height: 24)
              .padding(.bottom, 6)
            
            Text(category.type)
              .customFont(.caption2B)
              .padding(.bottom, 11)
            
            Divider()
              .frame(width: 30, height: 2)
              .overlay(.purple700)
              .opacity(selectQVM.selectedCategory == category ? 1 : 0)
          }
          .foregroundStyle(selectQVM.selectedCategory == category ? .purple700 : .gray400)
          .opacity(selectQVM.selectedCategory == category ? 1 : 0.4)
          .onTapGesture(perform: {
            selectQVM.selectCategory(seleted: category)
          })
        }
      }
      .padding(.horizontal, 29)
      .padding(.top, 36)
      
    }
  }
  
  private var bottomGradient: some View {
    Rectangle()
      .fill(LinearGradient(
        colors: [Color(hex: 0xF6F6F6), Color(hex: 0xF6F6F6).opacity(0)],
        startPoint: .top, endPoint: .bottom)
      )
      .frame(maxWidth: .infinity)
      .frame(height: 5)
  }
  
  private func questionItem(selectedQ: DBStaticQuestion) -> some View {
    return VStack {
      HStack {
        Text(selectedQ.content)
          .customFont(.subHeadlineR)
          .foregroundStyle(.gray500)
        Spacer()
      }
      .padding(.vertical, 20)
      .padding(.horizontal, 22)
      Divider()
        .frame(maxWidth: .infinity)
        .frame(height: 3)
        .overlay(.purple200)
    }
    .onTapGesture {
      selectQVM.questionClicked(selectedQ: selectedQ)
    }
    
  }
  
  private var questionListView: some View {
    VStack(spacing: 0) {
      
      ScrollViewReader { proxy in
        ScrollView(.vertical) {
          Spacer()
            .frame(height: 20)
            .id("top")
          
          ForEach(selectQVM.filteredLists, id: \.self) { question in
            questionItem(selectedQ: question)
          }
          Spacer()
            .frame(height: 50)
        }
        .onChange(of: selectQVM.selectedCategory) { new in
          proxy.scrollTo("top")
        }
        
      }
    }
  }
}

#Preview {
  SelectQuestionView()
}
