//
//  ConnectedView.swift
//  ABloom
//
//  Created by 정승균 on 10/27/23.
//

import SwiftUI

struct ConnectedView: View {
  @Environment(\.dismiss) private var dismiss

  @State var fianceName: String = ""
  
  let fianceId: String
  let imageSize: CGFloat = 206
  
  var body: some View {
    VStack {
      if fianceName == "" {
        ProgressView()
      } else {
        Image("check")
          .resizable()
          .frame(width: imageSize, height: imageSize)
        
        Text("\(fianceName)님과 연결되어 있습니다.")
          .fontWithTracking(.bodyR)
          .foregroundStyle(.stone800)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .task {
      guard let fianceName = try? await UserManager.shared.getUser(userId: fianceId).name
      else { return }
      
      self.fianceName = fianceName
    }
    .customNavigationBar {
      Text("상대방과 연결")
    } leftView: {
      Button {
        dismiss()
      } label: {
        NavigationArrowLeft()
      }
    } rightView: {
      EmptyView()
    }
    .background(backgroundDefault())
  }
}

#Preview {
  NavigationStack {
    ConnectedView(fianceId: "")
  }
}
