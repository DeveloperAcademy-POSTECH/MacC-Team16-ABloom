//
//  WriteAnswerView.swift
//  ABloom
//
//  Created by 정승균 on 11/15/23.
//

import SwiftUI

struct WriteAnswerView: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject var writeAMV = WriteAnswerViewModel()
  @Binding var isSheetOn: Bool
  
  var question: DBStaticQuestion
  
  var body: some View {
    VStack(alignment: .leading, spacing: 15) {
      
      questionText
      
      ZStack(alignment: .top) {
        
        textField
          .padding(.horizontal, -5)
        
        textNumCheck
          .position(x: UIScreen.main.bounds.size.width/2 - 20, y: UIScreen.main.bounds.size.height/3.5)
      }
      
    }
    .padding(.horizontal, 20)
    .ignoresSafeArea(.keyboard)
    .interactiveDismissDisabled(writeAMV.ansText.isEmpty ? false : true)
    .onAppear(perform: UIApplication.shared.hideKeyboard)
    
    // 네비게이션바
    .customNavigationBar {
      Text("답변 작성하기")
    } leftView: {
      Button(action: {
        writeAMV.backClicked()
        if !writeAMV.isCancelAlertOn {
          dismiss()
        }
      }, label: {
        NavigationArrowLeft()
      })
    } rightView: {
      Button(action: { writeAMV.completeClicked() }, label: {
        Text("완료")
          .customFont(.calloutB)
          .foregroundStyle((writeAMV.ansText.isEmpty || writeAMV.isTextOver) ? .gray400 : .primary80)
      })
      .disabled(writeAMV.ansText.isEmpty || writeAMV.isTextOver)
    }
    
    // 백버튼 알림
    .alert("작성을 종료할까요?", isPresented: $writeAMV.isCancelAlertOn, actions: {
      Button {
        writeAMV.swipeEnable()
        dismiss()
      } label: {
        Text("나가기")
      }
      Button(role: .cancel, action: {}, label: {
        Text("취소")
      })
    }, message: {
      Text("작성중이었던 답변은 저장되지 않아요.")
    })
    
    
    // 완료 알림
    .alert("답변을 완료할까요?", isPresented: $writeAMV.isCompleteAlertOn, actions: {
      Button {
        writeAMV.swipeEnable()
        try? writeAMV.createAnswer(qid: question.questionID, category: question.category)
        isSheetOn.toggle()
      } label: {
        Text("완료하기")
      }
      Button(role: .cancel, action: {}, label: {
        Text("취소")
      })
    }, message: {
      Text("완료한 답변은 수정할 수 없어요.")
        .multilineTextAlignment(.center)
    })
  }
}

extension WriteAnswerView {
  private var questionText: some View {
    Text(question.content)
      .customFont(.calloutB)
      .multilineTextAlignment(.leading)
      .padding(.top, 40)
  }
  
  private var textField: some View {
    
    TextEditor(text: $writeAMV.ansText)
      .opacity(writeAMV.ansText.isEmpty ? 0.2 : 1.0)
      .background(alignment: .topLeading) {
        TextEditor(text: .constant(writeAMV.ansText.isEmpty ? "내 답변을 작성해보세요..." : ""))
          .foregroundStyle(.gray500)
      }
      .foregroundStyle(.gray500)
      .accentColor(.primary60)
      .customFont(.calloutR)
      .multilineTextAlignment(.leading)
      .frame(maxWidth: .infinity)
      .frame(maxHeight: UIScreen.main.bounds.size.height/3.5 - 10) 
      .onChange(of: writeAMV.ansText, perform: { new in
        writeAMV.checkTextCount()
      })
  }
  
  private var textNumCheck: some View {
    HStack(spacing: 0) {
      Spacer()
      Text("\(writeAMV.ansText.count)")
        .customFont(.footnoteR)
        .foregroundStyle( writeAMV.isTextOver ? .red : .gray400)
      
      Text(" / 150")
        .customFont(.footnoteR)
        .foregroundStyle(.gray400)
    }
  }
}

#Preview {
  WriteAnswerView(isSheetOn: .constant(true), question: .init(questionID: 3, category: "communication", content: "Helloodoododo"))
}
