//
//  SelectQuestionView.swift
//  ABloom
//
//

import SwiftUI

struct SelectQuestionView: View {
  @StateObject var selectQVM = SelectQuestionViewModel()
  
  var selectedCategory: Category
  
  var body: some View {
    VStack(spacing: 0) {
      
      categoryBar
      bottomGradient
      
      questionListView
    }
    .task {
      selectQVM.fetchQuestions()
    }
    .onAppear {
      selectQVM.moveToSelectedCategory(selectedCategory: selectedCategory)
    }
    .sheet(isPresented: $selectQVM.isAnswerSheetOn) {
      if let selectedQ = selectQVM.selectedQuestion {
        WriteAnswerView(question: selectedQ)
      }
    }
  }
}

extension SelectQuestionView {
  
  private var categoryBar: some View {
    ScrollViewReader { proxy in
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 30) {
          
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
            
            .padding(.horizontal, 10)
            .tag(category)
            .foregroundStyle(selectQVM.selectedCategory == category ? .purple700 : .gray400)
            .opacity(selectQVM.selectedCategory == category ? 1 : 0.4)
            .onTapGesture(perform: {
              selectQVM.selectCategory(seleted: category)
            })
          }
        }
        .padding(.top, 36)
        .padding(.horizontal, 20)
      }
      .onChange(of: selectQVM.selectedCategory) { new in
        proxy.scrollTo(selectQVM.selectedCategory)
      }
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
        .frame(height: 2)
        .overlay(.purple100)
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
  SelectQuestionView(selectedCategory: Category.communication)
}
