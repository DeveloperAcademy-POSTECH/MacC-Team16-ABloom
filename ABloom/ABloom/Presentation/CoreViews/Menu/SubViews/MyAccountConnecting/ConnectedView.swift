//
//  ConnectedView.swift
//  ABloom
//
//  Created by 정승균 on 10/27/23.
//

import SwiftUI

struct ConnectedView: View {
  @State var fianceName: String = ""
  
  let fianceId: String
  let imageSize: CGFloat = 206
  
  var body: some View {
    VStack {
      Image("check")
        .resizable()
        .frame(width: imageSize, height: imageSize)
      
      Text("\(fianceName)님과 연결되어 있습니다.")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .navigationTitle("상대방과 연결")
    .navigationBarTitleDisplayMode(.inline)
    .background(backgroundDefault())
    .task {
      guard let fianceName = try? await UserManager.shared.getUser(userId: fianceId).name
      else { return }
      
      self.fianceName = fianceName
    }
  }
}

#Preview {
  NavigationStack {
    ConnectedView(fianceId: "")
  }
}
