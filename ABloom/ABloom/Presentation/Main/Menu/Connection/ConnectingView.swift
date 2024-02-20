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
      VStack(alignment: .leading, spacing: 0) {
        Text(explainText)
          .customFont(.caption1R)
          .foregroundStyle(.gray600)
          .padding(.bottom, 28)
        
        myCodeSection
          .padding(.bottom, 24)
        
        fianceCodeSection
          .padding(.bottom, 76)
        
        codeCopyButton
          .padding(.bottom, 8)
        
        shareByKakaoButton
        
        Spacer()
      }
      
      VStack {
        Spacer()
        if showToast {
          ToastView(message: "연결 코드가 복사되었습니다")
            .padding(.bottom, 36)
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
      
      ZStack {
        RoundedRectangle(cornerRadius: 8)
          .frame(height: 84)
          .foregroundStyle(.purple100)

        Text(vm.currentUser?.invitationCode ?? "로그인해주세요.")
          .font(.largeTitleB)
      }
    }
  }
  
  private var fianceCodeSection: some View {
    VStack(alignment: .leading) {
      Text("상대방의 연결 코드로 연결")
        .customFont(.calloutB)
        .foregroundStyle(.black)
        .padding(.bottom, 8)
      
      HStack(spacing: 4) {
        ConnectCodeStrokeInputField(codeInputText: $vm.inputText, isTargetCodeValid: vm.isTargetCodeInputVaild)
          
        Button {
          vm.connectUser()
        } label: {
          Text("연결")
            .font(.calloutB)
            .foregroundStyle(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 15)
            .background {
              RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(vm.inputText.isEmpty ? .purple200 : .purple800)
            }
        }
      }
      
    }
  }
  
  private var codeCopyButton: some View {
    ConnectionButton(title: "나의 연결 코드 복사하기", color: .white, image: "copy", hasStroke: true, action: {
      copyClipboard()
    })
  }
  
  private var shareByKakaoButton: some View {
    ConnectionButton(title: "카카오톡 공유하기", color: .init(hex: 0xFAE100), image: "kakaotalksymbol", action: {
      KakaoShareManager().shareMyCode()
    })
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
    
    MixpanelManager.connectCopy(code: vm.currentUser?.invitationCode ?? "")
  }
}
