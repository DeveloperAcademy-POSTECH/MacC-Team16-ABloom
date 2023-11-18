////
////  SelectQuestionView.swift
////  ABloom
////
////
//
//import SwiftUI
//
//struct SelectQuestionView: View {
//  @Environment(\.dismiss) private var dismiss
//  @StateObject var selectQVM = SelectQuestionViewModel()
//
//  
//  var body: some View {
//    VStack {
//      
//      categoryBar
//      
//      if selectQVM.isReady {
//        
//        questionListView
//          .background(backWall())
//        
//      } else {
//        
//        VStack {
//          ProgressView()
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(backWall())
//        
//      }
//    }
//    .navigationDestination(for: DBStaticQuestion.self, destination: { content in
//      AnswerWriteView(question: content, isFromMain: false)
//    })
//    
//    .onAppear {
//      if NavigationModel.shared.isPopToMain {
//        NavigationModel.shared.popToMainToggle()
//        dismiss()
//      }
//    }
//    
//    .task {
//      try? await selectQVM.fetchQuestions()
//    }
//  }
//}
//
//extension SelectQuestionView {
//  
//  private var categoryBar: some View {
//    ScrollView(.horizontal, showsIndicators: false) {
//      HStack(spacing: 50) {
//        
//        ForEach(Category.allCases, id: \.self) { category in
//          VStack(alignment: .center, spacing: 6) {
//            
//            Image(category.rawValue)
//              .resizable()
//              .frame(width: 24, height: 24)
//            
//            Text(category.type)
//              .fontWithTracking(selectQVM.selectedCategory == category ? .caption1Bold : .caption1R)
//              .foregroundStyle(.gray800)
//          }
//          .opacity(selectQVM.selectedCategory == category ? 1 : 0.4)
//          .onTapGesture(perform: {
//            selectQVM.selectCategory(seleted: category)
//          })
//        }
//      }
//      .padding(.horizontal, 29)
//      .padding(.bottom, 13)
//      .padding(.top, 36)
//      
//    }
//  }
//  
//  // MARK:  Lia's Lavine
//  private var questionListView: some View {
//    VStack(spacing: 0) {
//      
//      HStack {
//        Text("\(selectQVM.selectedCategory.type) 문답")
//          .fontWithTracking(.headlineBold)
//          .foregroundStyle(.stone700)
//        
//        Spacer()
//      }
//      .padding(.horizontal, 22)
//      .padding(.top, 34)
//      .padding(.bottom, 10)
//      
//      ScrollViewReader { proxy in
//        ScrollView(.vertical) {
//          Spacer()
//            .frame(height: 20)
//            .id("top")
//          
//          ForEach(selectQVM.filteredLists, id: \.self) { question in
//            NavigationLink(value: question) {
//              QuestionChatBubble(text: question.content)
//            }
//            .padding(.horizontal, 20)
//            .padding(.bottom, 17)
//            
//          }
//          Spacer()
//            .frame(height: 50)
//        }
//        .onChange(of: selectQVM.selectedCategory) { new in
//          proxy.scrollTo("top")
//        }
//        
//      }
//    }
//  }
//}
//
//#Preview {
//    SelectQuestionView()
//}
