//
//  MyAccountConnectingView.swift
//  ABloom
//
//  Created by 정승균 on 10/22/23.
//

import SwiftUI

@MainActor
final class MyAccountConnectingViewModel: ObservableObject {
  @Published var codeInputText: String = ""
  @Published var myCode: String?
  @Published var showToast = false
  
  var isTargetCodeVaild: Bool {
    !codeInputText.isEmpty
  }
  
  func getMyCode() async throws {
    let currentUser = try AuthenticationManager.shared.getAuthenticatedUser()
    print("현재 유저 -> \(currentUser)")
    self.myCode = try await UserManager.shared.getUser(userId: currentUser.uid).invitationCode
  }
}

struct MyAccountConnectingView: View {
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
      
      PinkSingleBtn(text: "상대방과 연결하기")
        .padding(.bottom, 60)
    }
    .navigationTitle("상대방과 연결")
    .navigationBarTitleDisplayMode(.inline)
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
        .font(.footnoteR)
        .foregroundStyle(.stone600)
      
      Spacer()
    }
  }
  
  private var myCodeBox: some View {
    VStack(alignment: .leading) {
      Text("나의 연결 코드")
        .font(.subheadline)
      
      HStack {
        Image(systemName: "clipboard.fill")
        
        Text(myAccountConnectingVM.myCode ?? "코드를 불러오지 못했습니다.")
        
        Spacer()
        
        Button(action: copyClipboard, label: {
          Text("복사")
            .font(.caption1R)
            .padding(.trailing, 15)
        })
      }
      .foregroundStyle(.stone950)
      .font(.calloutBold)
      .strokeInputFieldStyle(isValueValid: true, alignment: .leading)
    }
  }
  
  private var connectionCodeTextfield: some View {
    VStack(alignment: .leading) {
      Text("상대방의 연결 코드")
        .font(.subheadline)
      
      TextField("상대방의 연결코드를 입력해주세요.", text: $myAccountConnectingVM.codeInputText)
      .foregroundStyle(.stone950)
      .font(.calloutR)
      .strokeInputFieldStyle(isValueValid: myAccountConnectingVM.isTargetCodeVaild, alignment: .leading)
    }
  }
}

extension MyAccountConnectingView {
  private func copyClipboard() {
    UIPasteboard.general.string = myAccountConnectingVM.myCode
    withAnimation {
      myAccountConnectingVM.showToast.toggle()
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      withAnimation {
        myAccountConnectingVM.showToast = false
      }
    }
  }
}
