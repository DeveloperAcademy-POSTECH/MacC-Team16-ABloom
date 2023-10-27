//
//  MyAccountConnectingView.swift
//  ABloom
//
//  Created by 정승균 on 10/22/23.
//

import SwiftUI

struct MyAccountConnectingView: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject var myAccountConnectingVM = MyAccountConnectingViewModel()
  
  var body: some View {
    VStack(spacing: 30) {
      headerContent
        .padding(.top, 30)
      
      myCodeBox
      
      connectionCodeTextfield
      
      Spacer()
      
      if myAccountConnectingVM.showToast {
        ToastView(message: "코드가 복사되었습니다")
          .padding(.bottom, 30)
      }
     
      connectButton
    }
    .navigationTitle("상대방과 연결")
    .padding(.horizontal, 20)
    .background(backgroundDefault())
    .task {
      try? await myAccountConnectingVM.getMyCode()
    }
  }
}

#Preview {
  NavigationStack {
    MyAccountConnectingView()
  }
}

extension MyAccountConnectingView {
  private var headerContent: some View {
    HStack {
      Text("상대방과 연결하면 문답을 함께 작성해갈 수 있어요.\n내 초대코드를 복사해 연결할 상대방에게 알려주세요.")
        .fontWithTracking(.footnoteR, tracking: -0.4)
        .foregroundStyle(.stone600)
      
      Spacer()
    }
  }
  
  private var myCodeBox: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("나의 연결 코드")
        .fontWithTracking(.subHeadlineR)
      
      CopyStrokeInputField(myCode: myAccountConnectingVM.myCode) {
        myAccountConnectingVM.copyClipboard()
      }
    }
  }
  
  private var connectionCodeTextfield: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("상대방의 연결 코드")
        .fontWithTracking(.subHeadlineR)
      
      ConnectCodeStrokeInputField(codeInputText: $myAccountConnectingVM.codeInputText, isTargetCodeValid: myAccountConnectingVM.isTargetCodeInputVaild)
    }
  }
  
  private var connectButton: some View {
    Button(action: {
      Task {
        try? await myAccountConnectingVM.tryConnect()
      }
    }, label: {
      if myAccountConnectingVM.isTargetCodeInputVaild {
        PurpleSingleBtn(text: "상대방과 연결하기")
      } else {
        StoneSingleBtn(text: "상대방과 연결하기")
      }
    })
    .disabled(!myAccountConnectingVM.isTargetCodeInputVaild)
    .padding(.bottom, 40)
    
    .alert("연결에 실패했어요", isPresented: $myAccountConnectingVM.showAlert, actions: {
      Button("확인") { }
    }, message: {
      Text("상대방의 코드를 올바르게 입력했는지 확인해주세요.")
    })
  }
}
