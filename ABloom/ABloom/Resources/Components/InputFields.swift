//
//  InputFields.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/25/23.
//

import SwiftUI

/// 연결 코드 복사 뷰
struct CopyStrokeInputField: View {
  let myCode: String?
  let alignment: Alignment
  var copyAction: () -> Void

  var body: some View {
    ZStack {
      HStack {
        Text(myCode ?? "코드를 불러오지 못했습니다")
        
        if alignment == .leading {
          Spacer()
        }
      }
      
      HStack {
        Spacer()
        
        Button(action: copyAction, label: {
          Image("copy")
            .resizable()
            .scaledToFit()
            .frame(width: 20)
        })
      }
    }
  }
}

/// 연결 코드 입력 뷰
struct ConnectCodeStrokeInputField: View {
  @Binding var codeInputText: String
  let isTargetCodeValid: Bool
  
  var body: some View {
    TextField("상대방의 연결코드를 입력해주세요", text: $codeInputText)
    .foregroundStyle(.stone950)
    .font(.calloutR)
    .strokeInputFieldStyle(isValueValid: isTargetCodeValid, alignment: .leading)
  }
}

#Preview {
  VStack {
    CopyStrokeInputField(myCode: "fefefefs", alignment: .center) {
      
    }
    .strokeInputFieldStyle(isValueValid: true, alignment: .center)
    
    ConnectCodeStrokeInputField(codeInputText: .constant(""), isTargetCodeValid: false)
  }
}
