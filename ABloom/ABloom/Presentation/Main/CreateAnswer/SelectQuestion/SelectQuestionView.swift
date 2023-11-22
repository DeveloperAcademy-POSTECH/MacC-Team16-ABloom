//
//  SelectQuestionView.swift
//  ABloom
//
//

import SwiftUI

struct SelectQuestionView: View {
  @StateObject var selectQVM = SelectQuestionViewModel()
  @Environment(\.dismiss) private var dismiss
  @Binding var isSheetOn: Bool
  
  var selectedCategory: Category
  
  var body: some View {
    VStack(spacing: 0) {
      
      categoryBar
      bottomGradient
      
      if selectQVM.isLoggedIn {
        questionListView
      } else {
        staticQuestionListView
      }
    }
    
    .onAppear {
      if !selectQVM.didGetCategory {
        selectQVM.updateSelectedCategory(new: selectedCategory)
      }
    }
    
    .navigationDestination(isPresented: $selectQVM.isAnswerSheetOn, destination: {
      if let selectedQ = selectQVM.selectedQuestion {
        WriteAnswerView(isSheetOn: $isSheetOn, question: selectedQ)
      }
    })
    
    .navigationBarBackButtonHidden(true)
    
    
    .customNavigationBar {
      EmptyView()
    } leftView: {
      Button(action: {dismiss()
      }, label: {
        Image("angle-left")
          .resizable()
          .renderingMode(.template)
          .frame(width: 18, height: 18)
          .foregroundStyle(.purple700)
          .padding(.top, 21)
      })
    } rightView: {
      EmptyView()
    }
    .ignoresSafeArea(.all, edges: .bottom)
    
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
        .padding(.top, 32)
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
        .frame(height: 1)
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
  
  private var staticQuestionListView: some View {
    VStack(spacing: 0) {
      ZStack(alignment: .bottom) {
        
        Image(selectQVM.selectedCategory.staticImg)
          .resizable()
          .aspectRatio(contentMode: .fit)
        
        Rectangle()
          .foregroundStyle(.clear)
          .frame(height: UIScreen.main.bounds.size.height/1.6)
          .overlay(
            LinearGradient(
              colors: [.topBlur.opacity(0), .middleBlur.opacity(0.63), .bottomBlur],
              startPoint: .top,
              endPoint: .bottom)
          )
        
        Text("지금 로그인하면 메리의 200개가 넘는\n모든 질문들을 확인수 있어요!")
          .customFont(.footnoteB)
          .foregroundStyle(.gray50)
          .multilineTextAlignment(.center)
          .padding(.bottom, 108)
        
        // TODO: 로그인 팝업
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
          Text("로그인하기 >")
            .customFont(.calloutB)
            .foregroundStyle(.white)
        })
        .padding(.bottom, 66)
        
        
        
      }
    }
    .ignoresSafeArea(.all, edges: .bottom)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    
  }
}

#Preview {
  SelectQuestionView(isSheetOn: .constant(true), selectedCategory: Category.communication)
}
