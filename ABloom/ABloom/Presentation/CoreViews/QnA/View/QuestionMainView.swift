//
//  QuestionMainView.swift
//  ABloom
//
//  Created by yun on 10/22/23.
//

import SwiftUI

struct QuestionMainView: View {
  @StateObject var questionVM = QuestionMainViewModel()
  
  //  @State var path: [ViewContent] = []
  
  var body: some View {
    // TODO: path struct 정의 필요 -> Data 구조화 필요
    NavigationStack {
      VStack {
        // MARK: - Header
        
        HStack {
          Text("우리의 문답")
            .fontWithTracking(.title3Bold)
            .padding([.leading], 20)
          Spacer()
          // FIXME: 다른 뷰로 전환 시에는 다른 방식으로 처리해야함
          NavigationLink(value: 0) {
            Image("pencil_write_fill")
              .padding([.trailing], 17)
          }
        }
        .padding([.top], 20)
        .foregroundStyle(.stone700)
        
        Spacer()
          .frame(height: 34)
        
        // MARK: - Question List
        
        ScrollView(.vertical) {
          LazyVStack(spacing: 30) {
            Spacer()
              .frame(height: 0)
            ForEach(1..<10) { num in
              NavigationLink(value: num) {
                // TODO: 해당 정보란을 데이터로 가져와야함
                QnAListItem(categoryImg: "squareIcon_isometric_sofa", question: "나와 결혼을 결심한 순간은 언제야?\(num)", date: "2023년 9월 18일", isAns: false)
              }
            }
          }
        }
        // value에 따른 네비게이션
        // 같은 뷰 다른 데이터일 경우 struct 채택
        .navigationDestination(for: Int.self, destination: { content in
          if content == 0 {
            SelectQuestionView()
          } else {
            AnswerCheckView(num: content)
          }
        })
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backWall())
      }
      .background(backgroundDefault())
    }
  }
}

#Preview {
  QuestionMainView()
}
