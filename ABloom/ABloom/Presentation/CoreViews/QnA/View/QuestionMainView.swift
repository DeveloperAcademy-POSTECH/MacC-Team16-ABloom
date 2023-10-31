//
//  QuestionMainView.swift
//  ABloom
//
//  Created by yun on 10/22/23.
//

import SwiftUI

struct QuestionMainView: View {
  @StateObject var questionVM = QuestionMainViewModel()
  
  var body: some View {
    VStack {
      headerView
      
      Spacer()
        .frame(height: 34)
      
      if questionVM.isEmpty {
        emptyListView
          .background(backWall())
        
      } else {
        answeredQScroll
          .background(backWall())
      }
    }
    .navigationDestination(for: Int.self, destination: { content in
      if content == 0 {
        SelectQuestionView(sex: questionVM.sex)
      } else {
        AnswerCheckView(answerCheckVM: .init(questionId: content), sex: questionVM.sex)
      }
    })
    .background(backgroundDefault())
    
    .task {
      questionVM.getInfo()
    }
  }
}

extension QuestionMainView {
  private var headerView: some View {
    // 헤더
    HStack {
      Text("우리의 문답")
        .fontWithTracking(.title3Bold)
        .padding([.leading], 20)
      Spacer()
      // FIXME: 다른 뷰로 전환 시에는 다른 방식으로 처리해야함
      NavigationLink(value: 0) {
        Image("pencil_write_fill")
      }
      .padding(.trailing, 17)
    }
    .padding(.top, 20)
    .foregroundStyle(.stone700)
  }
  
  // 질문 목록
  private var answeredQScroll: some View {
    
    ScrollView(.vertical) {
      Spacer()
        .frame(height: 30)
      
      LazyVStack(spacing: 30) {
        
        ForEach(questionVM.questions, id: \.questionID) { question in
          NavigationLink(value: question.questionID) {
            QnAListItem(
              categoryImg: (Category(rawValue: question.category)?.imgName)!,
              question: question.content,
              date: (questionVM.answers.last(where: { $0.questionId == question.questionID })?.date)!,
              isAns: questionVM.checkAnswerStatus(qid: question.questionID))
          }
        }
        // 탭 바로 가려지는 부분 뷰 처리
        Spacer()
          .frame(height: 20)
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
      .foregroundStyle(.stone400)
      .frame(maxWidth: .infinity)
      .frame(height: 114)
      .background(
        RoundedRectangle(cornerRadius: 12)
          .stroke(Color.stone300)
          .foregroundStyle(.clear)
      )
      .padding(.horizontal, 20)
      .padding(.top, 35)
      
      Spacer()
    }
  }
}

#Preview {
  QuestionMainView()
}
