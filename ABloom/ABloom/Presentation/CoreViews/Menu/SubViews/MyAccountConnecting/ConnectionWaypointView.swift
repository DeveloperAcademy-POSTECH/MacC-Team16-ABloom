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
      if waypointVM.isReady {
        if let fianceId = waypointVM.currentUser?.fiance,
           let myCode = waypointVM.currentUser?.invitationCode
        {
          ConnectedView(fianceId: fianceId, myCode: myCode)
        } else {
          MyAccountConnectingView()
        }
      } else {
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(backgroundDefault())
          .navigationBarBackButtonHidden(true)
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
