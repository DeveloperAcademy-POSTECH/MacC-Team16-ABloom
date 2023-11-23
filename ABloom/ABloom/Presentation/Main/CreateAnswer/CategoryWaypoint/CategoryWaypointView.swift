//
//  CategoryWaypointView.swift
//  ABloom
//
//  Created by 정승균 on 11/15/23.
//

import SwiftUI

struct CategoryWaypointView: View {
  @StateObject var categoryWayVM = CategoryWaypointViewModel()
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
    
      // FIXME: 안되고 있음
      .sheet(isPresented: $categoryWayVM.activeSheet.showSheet) {
        categoryWayVM.activeSheet.checkSheet()
      }
      
      .navigationDestination(isPresented: $categoryWayVM.isSelectSheetOn, destination: {
        SelectQuestionView(isSheetOn: $isSheetOn, selectedCategory: categoryWayVM.selectedCategory)
          .ignoresSafeArea()
      })
      
      .task {
        try? await categoryWayVM.loadRecommendedQuestion()
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
      .padding(.top, 16)
      
      .ignoresSafeArea(.all, edges: .bottom)
    }
  }
}

extension CategoryWaypointView {
  
  private var recommenedArea: some View {
    return Button {
      
      // FIXME: 로그인 팝업 .sheet가 안 뜨는 현상 해결하기
      if !categoryWayVM.isLoggedIn {
        categoryWayVM.loginSheetOn()
        print(categoryWayVM.activeSheet.showSheet)
      } else if categoryWayVM.isAnswered { // TODO: 내비게이션 변수 처리
        // 문답확인뷰 이동
      } else {
        // 문답 작성뷰 이동 변수 처리
        //        WriteAnswerView(isSheetOn: $isSheetOn, question: categoryWayVM.recommendQuestion)
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
          }
      }
    }
  }
}

#Preview {
  CategoryWaypointView(isSheetOn: .constant(true))
}
