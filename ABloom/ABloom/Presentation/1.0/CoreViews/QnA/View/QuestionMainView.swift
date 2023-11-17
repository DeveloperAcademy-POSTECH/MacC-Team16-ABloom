//
//  QuestionMainView.swift
//  ABloom
//
//  Created by yun on 10/22/23.
//

import SwiftUI

struct QuestionMainView: View {
  init() {
    checkFont()
  }
  
  func checkFont() {
       
    for familyName in UIFont.familyNames {
               print("Font Family Name: \(familyName)")
               for fontName in UIFont.fontNames(forFamilyName: familyName) {
                   print("    Font Name: \(fontName)")
               }
           }
  }
  @StateObject var questionVM = QuestionMainViewModel()
  
  var body: some View {
    VStack {
      headerView
      
      Spacer().frame(height: 40)
      
      switch questionVM.viewState {
      case .isProgress:
        ProgressView()
          .frame(maxHeight: .infinity)
      case .isEmpty:
        emptyListView
      case .isSorted:
        answeredQScroll
      }
    }
    .background(backgroundDefault())
    
    .navigationDestination(for: Int.self, destination: { content in
      if content == 0 {
        SelectQuestionView(sex: questionVM.sex)
      } else {
        AnswerCheckView(answerCheckVM: .init(questionId: content), sex: questionVM.sex)
      }
    })
    
    .task {
      questionVM.getInfo()
    }
  }
}

extension QuestionMainView {
  // 헤더
  private var headerView: some View {
    HStack {
      Text("우리의 문답")
        .fontWithTracking(.title3Bold)
      Spacer()
      // FIXME: 다른 뷰로 전환 시에는 다른 방식으로 처리해야함
      NavigationLink(value: 0) {
        Image("pencil_write_fill")
      }
      .padding(.trailing, -3)
    }
    .padding([.top, .horizontal], 20)
    .foregroundStyle(.stone700)
  }
  
  // 질문 목록
  private var answeredQScroll: some View {
    ScrollView(.vertical) {
      LazyVStack(spacing: 12) {
        ForEach(questionVM.questions, id: \.questionID) { question in
          NavigationLink(value: question.questionID) {
            QnAListItem(
              category: Category(rawValue: question.category) ?? .child,
              question: question.content,
              answerStatus: questionVM.checkAnswerStatus(qid: question.questionID)
            )
          }
          .padding(.horizontal, 20)
        }
        
        // 탭 바로 가려지는 부분 뷰 처리
        Spacer().frame(height: 30)
      }
    }
  }
  
  private var emptyListView: some View {
    VStack {
      VStack(spacing: 6) {
        HStack(spacing: 7) {
          Text("오른쪽 상단의")
          Image("pencilInText")
            .resizable()
            .frame(width: 20, height: 20)
          Text("버튼을 눌러")
        }
        Text("첫번째 문답을 작성해보세요.")
      }
      .fontWithTracking(.calloutR, tracking: -0.4)
      .foregroundStyle(.stone500)
      .frame(maxWidth: .infinity)
      .frame(height: 141)
      .background(Color.white)
      .cornerRadius(12, corners: .allCorners)
      
      Spacer()
    }
    .padding(.horizontal, 20)
  }
}

#Preview {
  QuestionMainView()
}
