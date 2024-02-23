//
//  WithdrawalMembershipView.swift
//  ABloom
//
//  Created by 정승균 on 11/21/23.
//

import SwiftUI

struct WithdrawalMembershipView: View {
  @Environment(\.dismiss) private var dismiss
  @State var showDeleteAlert: Bool = false
  @Binding var showProfileMenuSheet: Bool
  
  private let title = "메리를 탈퇴하시나요?"
  private let content1 = "지금까지 메리를 이용해주셔서 감사합니다.\n회원님께 더 나은 서비스를 제공해드리지 못한 것 같아 무거운 마음이 큽니다.\n\n"
  private let content2 = "이제 탈퇴하기를 누르시면 회원탈퇴가 진행되며, 저장된 개인정보가 안전하게 삭제되고 연결되어있던 상대방과의 연결이 자동으로 해제됩니다.\n\n"
  private let content3 = "앞으로 계속 노력하고 발전하는 메리가 되어 회원님을 다시 만날 수 있기를 바라며, 회원님의 앞날을 항상 응원하겠습니다."
  
  private let alertMessage = "회원 탈퇴를 하시면 문답 데이터가 모두 삭제되고, 복구할 수 없게 되며, 상대방과의 연결이 끊어집니다."
  
  var body: some View {
    VStack(spacing: 0) {
      VStack(alignment: .leading, spacing: 0) {
        Text(title)
          .foregroundStyle(.gray900)
          .customFont(.title2B)
          .padding(.bottom, 24)
        
        Text(content1 + content2 + content3)
          .foregroundStyle(.gray700)
          .customFont(.subHeadlineR)
      }
      
      Spacer()
      
      Button {
        showDeleteAlert = true
      } label: {
        Text("탈퇴하기 >")
          .customFont(.calloutB)
          .foregroundStyle(.gray500)
      }
      .padding(.bottom, 20)
      .frame(alignment: .center)
      

      Button {
        dismiss()
      } label: {
        PurpleTextButton(title: "다시 사용하기")
      }
    }
    .padding(.top, 54)
    .padding(.horizontal, 20)
    
    .customNavigationBar(centerView: {
      EmptyView()
    }, leftView: {
      Button {
        dismiss()
      } label: {
        Image("angle-left")
          .resizable()
          .renderingMode(.template)
          .scaledToFit()
          .frame(width: 18)
          .foregroundStyle(.purple700)
      }
    }, rightView: {
      EmptyView()
    })
    
    .alert("정말 메리를 탈퇴하시겠어요?", isPresented: $showDeleteAlert) {
      Button("취소", role: .cancel) {
        showDeleteAlert = false
      }
      
      Button("회원 탈퇴") {
        Task {
          try? await UserManager.shared.deleteUser()
          try? await AuthenticationManager.shared.delete()
        }
        
        showProfileMenuSheet = false
      }
    } message: {
      Text(alertMessage)
    }
  }
}

#Preview {
  WithdrawalMembershipView(showProfileMenuSheet: .constant(false))
}
