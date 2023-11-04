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
  @State var showToast = false
  
  let fianceId: String
  let myCode: String
  let imageSize: CGFloat = 206
  
  var body: some View {
    VStack(spacing: 0) {
      
      if fianceName == "" {
        ProgressView()
      } else {
        Image("check")
          .resizable()
          .scaledToFill()
          .frame(width: imageSize, height: imageSize)
          .padding(.bottom, 10)
        
        Text("\(fianceName)님과 연결되어 있습니다.")
          .fontWithTracking(.bodyR, tracking: -0.4)
          .foregroundStyle(.stone800)
          .padding(.bottom, 50)
        
        myCodeBox
          .padding(.horizontal, 20)
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
    ConnectedView(fianceId: "", myCode: "")
  }
}

extension ConnectedView {
  private var myCodeBox: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("나의 연결 코드")
        .fontWithTracking(.subHeadlineR)
      
      CopyStrokeInputField(myCode: myCode, copyAction: copyClipboard)
    }
  }
  
  private func copyClipboard() {
    UIPasteboard.general.string = myCode
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
