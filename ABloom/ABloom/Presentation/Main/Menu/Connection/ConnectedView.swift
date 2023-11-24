//
//  ConnectedView.swift
//  ABloom
//
//  Created by 정승균 on 11/22/23.
//

import SwiftUI

struct ConnectedView: View {
  let myCode: String
  let fianceName: String
  
  @State var showToast = false
  
  let viewHorizontalPadding: CGFloat = 20
  var checkCirclePadding: CGFloat {
    100 - viewHorizontalPadding
  }
  
  var body: some View {
    
    ZStack {
      VStack {
        Image("check")
          .resizable()
          .scaledToFit()
          .padding(.horizontal, checkCirclePadding)
          .padding(.bottom, 31)
        
        CopyStrokeInputField(myCode: myCode, alignment: .center, copyAction: copyClipboard)
          .strokeInputFieldStyle(isValueValid: true, alignment: .center)
          .padding(.bottom, 31)
        
        Text("\(fianceName)님과\n연결되어 있어요.")
          .customFont(.title3B)
          .foregroundStyle(.gray600)
          .multilineTextAlignment(.center)
      }
      .padding(.horizontal, viewHorizontalPadding)
      
      
      VStack {
        Spacer()
        if showToast {
          ToastView(message: "코드가 복사되었습니다")
            .padding(.bottom, 50)
        }
      }
    }
  }
}

#Preview {
  ConnectedView(myCode: "9HZI4ZHHjW", fianceName: "최지은")
}

extension ConnectedView {
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
