//
//  SelectQuestionView.swift
//  ABloom
//
//

import SwiftUI

struct SelectQuestionView: View {
  let isLoggedIn: Bool
  
  @StateObject var selectQVM = SelectQuestionViewModel()
  @StateObject var activeSheet: ActiveSheet
  @Environment(\.dismiss) private var dismiss
  @Binding var isSheetOn: Bool
  
  var selectedCategory: Category
  
  var body: some View {
    VStack(spacing: 0) {
      
      categoryBar
      bottomGradient
      
      if isLoggedIn {
        questionListView
      } else {
        previewStaticQuesiton
      }
    }
    .customNavigationBar {
      EmptyView()
    } leftView: {
      Button(action: {dismiss()
      }, label: {
        NavigationArrowLeft()
      })
    } rightView: {
      EmptyView()
    }
    .padding(.top, 5)
    
    .ignoresSafeArea(.all, edges: .bottom)
    
    
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
      MixpanelManager.qnaSelectQuestion(questionId: selectedQ.questionID)
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
  
  private var previewStaticQuesiton: some View {
    
    GeometryReader { geometry in
      ZStack(alignment: .bottom) {
        Image(selectQVM.selectedCategory.staticImg)
          .resizable()
          .scaledToFill()
          .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
          .clipped()
        
        VStack {
          Text("지금 로그인하면 메리의 200개가 넘는\n모든 질문들을 확인할 수 있어요!")
            .customFont(.footnoteB)
            .foregroundStyle(.gray50)
            .multilineTextAlignment(.center)
            .padding(.bottom, 15)
          
          Button {
            isSheetOn.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              activeSheet.kind = .signIn
            }
          } label: {
            Text("로그인하기 >")
              .padding(.bottom, 3)
              .underline(true)
              .customFont(.calloutB)
              .foregroundStyle(.white)
              .padding(.bottom, 66)
          }
        }
        .padding(.horizontal, 20) // Adjust horizontal padding if needed
      }
    }
    .edgesIgnoringSafeArea(.all)
  }
}
