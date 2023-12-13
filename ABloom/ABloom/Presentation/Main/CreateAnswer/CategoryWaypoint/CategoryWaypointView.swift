//
//  CategoryWaypointView.swift
//  ABloom
//
//  Created by 정승균 on 11/15/23.
//

import SwiftUI

struct CategoryWaypointView: View {
  @StateObject var categoryWayVM = CategoryWaypointViewModel()
  @StateObject var activeSheet: ActiveSheet
  @Environment(\.dismiss) private var dismiss
  @Binding var isSheetOn: Bool
  
  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading, spacing: 35) {
          
          recommenedArea
            .padding(.top, 20)
          
          Text("카테고리 선택하기")
            .customFont(.headlineB)
          
          categoryList
          
          Spacer()
        }
        .padding(.horizontal, 20)
      }
      
      .navigationDestination(isPresented: $categoryWayVM.isSelectSheetOn, destination: {
        SelectQuestionView(isLoggedIn: !(categoryWayVM.questionStatus == .notLoggedIn), activeSheet: activeSheet, isSheetOn: $isSheetOn, selectedCategory: categoryWayVM.selectedCategory)
      })
      
      .navigationDestination(isPresented: $categoryWayVM.isRecommenedNavOn, destination: {
        if categoryWayVM.questionStatus == .answered {
          CheckAnswerView(question: categoryWayVM.recommendQuestion)
        } else if categoryWayVM.questionStatus == .notAnswered {
          WriteAnswerView(isSheetOn: $isSheetOn, question: categoryWayVM.recommendQuestion)
        }
      })
      
      .task {
        try? await categoryWayVM.loadRecommendedQuestion()
        categoryWayVM.checkLogin()
      }
      
      .customNavigationBar {
        EmptyView()
      } leftView: {
        Button("취소") {
          dismiss()
        }
        .foregroundStyle(.purple600)
        .customFont(.calloutB)
      } rightView: {
        EmptyView()
      }
      
      .ignoresSafeArea(.all, edges: .bottom)
    }
  }
}

extension CategoryWaypointView {
  
  private var recommenedArea: some View {
    return Button {
      if categoryWayVM.questionStatus == .notLoggedIn {
        dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          activeSheet.kind = .signIn
        }
        MixpanelManager.signInTry(loginPoint: "createQna")
      } else {
        categoryWayVM.recommenedQClicked()
      }
    } label: {
      VStack(alignment: .leading, spacing: 5) {
        
        HStack {
          Text("오늘의 추천 질문")
            .customFont(.caption2B)
            .foregroundStyle(.gray300)
            .padding(15)
          Spacer()
        }
        
        Text(categoryWayVM.recommendQuestion.content)
          .multilineTextAlignment(.leading)
          .customFont(.headlineB)
          .foregroundStyle(.white)
          .padding(15)
      }
      .frame(maxWidth: .infinity)
      .background(
        RoundedRectangle(cornerRadius: 8)
          .foregroundStyle(.purple800)
      )
    }
  }
  
  private var categoryList: some View {
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    return LazyVGrid(columns: columns, spacing: 20) {
      ForEach(Category.allCases, id: \.self) { category in
        
        Text(category.type)
          .customFont(.headlineB)
          .foregroundColor(.white)
          .frame(width: 100, height: 100)
          .background(
            Image("\(category.rawValue)Img")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
          )
          .onTapGesture {
            categoryWayVM.isClicked(selectedCategory: category)
            MixpanelManager.qnaCategory(category: category.rawValue)
          }
      }
    }
  }
}
