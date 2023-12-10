//
//  ConnectingView.swift
//  ABloom
//
//  Created by 정승균 on 11/22/23.
//

import SwiftUI

struct ConnectingView: View {
  let explainText = "상대방과 연결하면 우리만의 결혼문답을 함께 써갈 수 있어요.\n내 연결 코드를 복사해 연결할 상대방에게 알려주세요."
  
  @ObservedObject var vm: ConnectionViewModel
  
  @State var showToast = false
  
  var body: some View {
    ZStack {
      VStack(alignment: .leading) {
        Text(explainText)
          .customFont(.caption1R)
          .foregroundStyle(.gray600)
          .padding(.bottom, 40)
        
        myCodeSection
          .padding(.bottom, 24)
        
        fianceCodeSection
        
        Spacer()
        
        connectButton
          .padding(.bottom, 20)
      }
      
      VStack {
        Spacer()
        if showToast {
          ToastView(message: "코드가 복사되었습니다")
            .padding(.bottom, 100)
        }
      }
    }
    .padding(.top, 39)
    .padding(.horizontal, 20)
    
    .onAppear(perform: UIApplication.shared.hideKeyboard)
    
    .alert("연결에 실패했어요", isPresented: $vm.showErrorAlert, actions: {
      Button("확인") {
        vm.showErrorAlert = false
      }
    }, message: {
      Text(vm.errorMessage)
    })
  }
}

#Preview {
  ConnectingView(vm: ConnectionViewModel())
}

extension ConnectingView {
  private var myCodeSection: some View {
    VStack(alignment: .leading) {
      Text("나의 연결 코드")
        .customFont(.calloutB)
        .foregroundStyle(.black)
        .padding(.bottom, 8)
      
      CopyStrokeInputField(myCode: vm.currentUser?.invitationCode ?? "로그인해주세요.", alignment: .leading, copyAction: copyClipboard)
        .strokeInputFieldStyle(isValueValid: true, alignment: .leading)
      
    }
  }
  
  private var fianceCodeSection: some View {
    VStack(alignment: .leading) {
      Text("상대방의 연결코드")
        .customFont(.calloutB)
        .foregroundStyle(.black)
        .padding(.bottom, 8)
      
      ConnectCodeStrokeInputField(codeInputText: $vm.inputText, isTargetCodeValid: vm.isTargetCodeInputVaild)
      
    }
  }
  
  private var connectButton: some View {
    Button {
      vm.connectUser()
    } label: {
      PurpleTextButton(title: "연결하기", isDisable: !vm.isTargetCodeInputVaild)
    }
    
  }
  
  private func copyClipboard() {
    UIPasteboard.general.string = vm.currentUser?.invitationCode ?? ""
    
    withAnimation {
      showToast.toggle()
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      withAnimation {
        self.showToast = false
      }
    }
  }
}
