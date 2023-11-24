//
//  ConnectionView.swift
//  ABloom
//
//  Created by 정승균 on 11/15/23.
//

import SwiftUI

struct ConnectionView: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject var vm = ConnectionViewModel()
  
  var body: some View {
    VStack {
      if let fianceUser = vm.fianceUser {
        ConnectedView(myCode: vm.currentUser?.invitationCode ?? "코드를 불러오지 못함", fianceName: fianceUser.name ?? "이름을 불러오지 못함")
      } else {
        ConnectingView(vm: vm)
      }
    }
    
    .customNavigationBar {
      Text("상대방과 연결 관리")
        .customFont(.bodyB)
    } leftView: {
      Button {
        dismiss()
      } label: {
        NavigationArrowLeft()
      }
    } rightView: {
      EmptyView()
    }

  }
}

#Preview {
  ConnectionView()
}
