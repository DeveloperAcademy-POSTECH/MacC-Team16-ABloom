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
    VStack(alignment: .leading, spacing: 20) {
      
      questionText
      
      textField
      
      textNumCheck
      
    }
    .padding(.horizontal, 20)
    
    .interactiveDismissDisabled()
    
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
        Image("angle-left")
          .resizable()
          .renderingMode(.template)
          .frame(width: 18, height: 18)
          .foregroundStyle(.purple700)
      })
    } rightView: {
      Button(action: { writeAMV.completeClicked() }, label: {
        Text("완료")
          .customFont(.calloutB)
          .foregroundStyle((writeAMV.ansText.isEmpty || writeAMV.isTextOver) ? .gray400 : .purple700)
      })
      .disabled(writeAMV.ansText.isEmpty || writeAMV.isTextOver)
    }
    
    // 백버튼 알림
    .alert("작성을 종료할까요?", isPresented: $writeAMV.isCancelAlertOn, actions: {
      Button {
        UINavigationController.isSwipeBackEnabled = true
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
        UINavigationController.isSwipeBackEnabled = true
        isSheetOn.toggle()
      } label: {
        Text("완료하기")
      }
      Button(role: .cancel, action: {}, label: {
        Text("취소")
      })
    }, message: {
      Text("완료한 답변은 수정할 수 없고,\n상대방은 내 답변을 확인할 수 있어요.")
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
    TextField("", text: $writeAMV.ansText, axis: .vertical)
      .placeholder(when: writeAMV.ansText.isEmpty, placeholder: {
        Text("내 답변을 작성해보세요...")
          .customFont(.calloutR)
          .foregroundStyle(.gray400)
      })
      .customFont(.calloutR)
      .foregroundStyle(.gray500)
      .frame(maxWidth: .infinity)
      .onChange(of: writeAMV.ansText, perform: { _ in
        writeAMV.checkTextCount()
        
        
      })
  }
  
  private var textNumCheck: some View {
    VStack {
      Spacer()
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
    .padding(.bottom, UIScreen.main.bounds.size.height/2.5)
  }
}

#Preview {
  
  WriteAnswerView(isSheetOn: .constant(true), question: .init(questionID: 3, category: "communication", content: "Helloodoododo"))
  
}
