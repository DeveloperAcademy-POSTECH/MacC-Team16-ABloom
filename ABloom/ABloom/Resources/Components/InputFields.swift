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
  var copyAction: () -> Void

  var body: some View {
    HStack {
      Image(systemName: "clipboard.fill")
        .font(.calloutR)
        .foregroundStyle(.stone900)
     
      Text(myCode ?? "코드를 불러오지 못했습니다")
        .fontWithTracking(.calloutBold, tracking: -0.4)
        .foregroundStyle(.stone900)
      
      Spacer()
      
      Button(action: copyAction, label: {
        Text("복사")
          .fontWithTracking(.caption1R, tracking: -0.4)
          .foregroundStyle(.black)
      })
    }
    .foregroundStyle(.purple600)
    .strokeInputFieldStyle(isValueValid: true, alignment: .leading)
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
