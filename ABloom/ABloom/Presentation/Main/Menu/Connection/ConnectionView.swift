//
//  ConnectionView.swift
//  ABloom
//
//  Created by 정승균 on 11/15/23.
//

import SwiftUI

struct ConnectionView: View {
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    VStack {
      
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
