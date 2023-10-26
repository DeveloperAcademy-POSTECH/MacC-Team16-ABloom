//
//  ConnectionWaypointView.swift
//  ABloom
//
//  Created by 정승균 on 10/27/23.
//

import SwiftUI

struct ConnectionWaypointView: View {
  @StateObject var waypointVM = ConnectionWaypointViewModel()
  
  var body: some View {
    VStack {
      if let fianceId = waypointVM.currentUser?.fiance {
        ConnectedView(fianceId: fianceId)
      } else {
        MyAccountConnectingView()
      }
    }
    .task {
      try? await waypointVM.getUser()
    }
  }
}

#Preview {
  ConnectionWaypointView()
}
