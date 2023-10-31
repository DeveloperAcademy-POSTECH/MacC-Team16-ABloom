//
//  ConnectionView.swift
//  ABloom
//
//  Created by 정승균 on 10/22/23.
//

import SwiftUI

struct ConnectionView: View {

  @Environment(\.dismiss) private var dismiss
  @StateObject var connectionVM = ConnectionViewModel()
  @Binding var showLoginView: Bool

  var body: some View {
    VStack(spacing: 30) {
      headerContent
        .padding(.top, 30)
      
      myCodeBox
      
      connectionCodeTextfield
      
      Spacer()
      
      if connectionVM.showToast {
        ToastView(message: "코드가 복사되었습니다")
          .padding(.bottom, 30)
      }
      
      withoutConnectButton
      
      connectButton
    }
    .padding(.horizontal, 20)
    .task {
      try? await connectionVM.getMyCode()
    }
    .customNavigationBar(
      centerView: {
        Text("상대방과 연결")
      },
      leftView: {
        Button { 
          dismiss()
        } label: {
          NavigationArrowLeft()
        }
      },
      rightView: {
        EmptyView()
      })
    .background(backgroundDefault())
  }
}

#Preview {
  ConnectionView(showLoginView: .constant(true))
}

extension ConnectionView {
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
      
      CopyStrokeInputField(myCode: connectionVM.myCode, copyAction: connectionVM.copyClipboard)
    }
  }
  
  private var connectionCodeTextfield: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("상대방의 연결 코드")
        .fontWithTracking(.subHeadlineR)
      
      ConnectCodeStrokeInputField(codeInputText: $connectionVM.codeInputText, isTargetCodeValid: connectionVM.isTargetCodeInputVaild)
    }
  }
  
  private var withoutConnectButton: some View {
    Button(action: {
      showLoginView = false
    }, label: {
      TextBtn()
    })
    .padding(.bottom, -10)
  }
  
  private var connectButton: some View {
    Button(action: {
      Task {
        try? await connectionVM.tryConnect()
        try? await connectionVM.getConnectionStatus()
        if connectionVM.isConnected {
          showLoginView = false
        }
      }
    }, label: {
      if connectionVM.isTargetCodeInputVaild {
        PurpleSingleBtn(text: "상대방과 연결하기")
      } else {
        StoneSingleBtn(text: "상대방과 연결하기")
      }
    })
    .disabled(!connectionVM.isTargetCodeInputVaild)
    .padding(.bottom, 40)
    
    .alert("연결에 실패했어요", isPresented: $connectionVM.showAlert, actions: {
      Button("확인") { }
    }, message: {
      Text(connectionVM.errorMessage)
    })
  }
}
