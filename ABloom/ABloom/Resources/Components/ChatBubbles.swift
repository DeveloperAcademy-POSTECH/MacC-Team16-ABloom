//
//  ChatBubbleComponents.swift
//  ABloom
//
//  Created by yun on 10/19/23.
//

import SwiftUI

/*
 Customized Chat Bubble structs
 
 - 가로 길이는 고정, 세로 길이는 글자 입력에 따라 늘어날 수 있도록 조정
 - 텍스트 중앙 정렬, 여러 줄일 때는 leading
 
 <참고사항>
 - background()와의 간격을 위해 background() 이전 padding(5) 고려
 => 디자인 사이즈 조절로 벤틀리와 상의 후 추가 예정
 - Figma에 Radius가 명시되어 있지 않아 확정 필요
 */

let paddingV = 10.0

struct LeftBlueChatBubble: View {
  let text: String
  
  var body: some View {
    HStack {
      Text(text)
        .fontWithTracking(.footnoteR, tracking: -0.4)
        .foregroundStyle(.stone900)
        .padding(paddingV)
        .multilineTextAlignment(.leading)
        .background(
          Rectangle()
            .foregroundStyle(.blue100)
            .cornerRadius(10, corners: [.topRight, .bottomRight, .bottomLeft])
        )
        .frame(minHeight: 20, alignment: .center)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      Spacer()
    }
  }
}

struct RightBlueChatBubble: View {
  let text: String
  
  var body: some View {
    HStack {
      Spacer()
      
      Text(text)
        .fontWithTracking(.footnoteR, tracking: -0.4)
        .foregroundStyle(.stone900)
        .padding(paddingV)
        .background(
          Rectangle()
            .foregroundStyle(.blue100)
            .cornerRadius(10, corners: [.topLeft, .bottomRight, .bottomLeft])
        )
        .frame(minHeight: 16, alignment: .center)
        .frame(maxWidth: 270, alignment: .trailing)
    }
  }
}

struct LeftPinkChatBubble: View {
  let text: String
  
  var body: some View {
    HStack {
      
      Text(text)
        .fontWithTracking(.footnoteR, tracking: -0.4)
        .foregroundStyle(.stone900)
        .padding(paddingV)
        .background(
          Rectangle()
            .foregroundStyle(.pink100)
            .cornerRadius(10, corners: [.topRight, .bottomRight, .bottomLeft])
        )
        .frame(minHeight: 16, alignment: .center)
        .frame(maxWidth: 270, alignment: .leading)
      
      Spacer()
    }
  }
}

struct RightPinkChatBubble: View {
  let text: String
  
  var body: some View {
    HStack {
      Spacer()
      
      Text(text)
        .fontWithTracking(.footnoteR, tracking: -0.4)
        .foregroundStyle(.stone900)
        .padding(paddingV)
        .background(
          Rectangle()
            .foregroundStyle(.pink100)
            .cornerRadius(10, corners: [.topLeft, .bottomRight, .bottomLeft])
        )
        .frame(minHeight: 16, alignment: .center)
        .frame(maxWidth: 270, alignment: .trailing)
    }
  }
}

struct BlueChatBubbleTextField: View {
  @Binding var text: String
  
  var body: some View {
    
    TextField("나의 생각은...", text: $text, axis: .vertical)
    // BUG
    // fontWithTracking 적용시, 텍스트 미입력 시 커서 사이즈가 default 값으로 진행되어, 텍스트를 입력하면 챗버블의 height가 조절됩니다.
    // 아래처럼 풀어서 기재할 시 해당 버그가 나타나지 않아서 아래와 같이 작성했습니다.
    
      .font(.custom("SpoqaHanSansNeo-Regular", size: 12))
      .tracking(-0.4)
     
      .foregroundStyle(.white)
      .multilineTextAlignment(.leading)
      .padding(paddingV)
      .background(
        Rectangle()
          .clayMorpMDShadow()
          .foregroundStyle(.blue500)
          .cornerRadius(10, corners: [.topLeft, .bottomRight, .bottomLeft])
      )
      .frame(minHeight: 30, alignment: .center)
      .frame(width: 242, alignment: .center)
     
  }
}

struct PinkChatBubbleTextField: View {
  @Binding var text: String
  
  var body: some View {
    
    TextField("나의 생각은...", text: $text, axis: .vertical)
      .font(.custom("SpoqaHanSansNeo-Regular", size: 12))
      .tracking(-0.4)
      .foregroundStyle(.white)
      .padding(paddingV)
      .frame(width: 242, alignment: .center)
      .frame(minHeight: 30, alignment: .center)
      .background(
        Rectangle()
          .clayMorpMDShadow()
          .foregroundStyle(.pink500)
          .cornerRadius(10, corners: [.topLeft, .bottomRight, .bottomLeft])
      )
      .frame(minHeight: 30, alignment: .center)
      .frame(width: 242, alignment: .center)
  }
  
}

#Preview {
  Group {
    LeftBlueChatBubble(text: "누가 재정관리를 하는 게 좋을까?")
      .padding()
    RightBlueChatBubble(text: "누가 재정관리를 하는 게 좋을까?")
      .padding()
    LeftPinkChatBubble(text: "얼마나 자주 데이트를 하고 싶어?")
      .padding()
    RightPinkChatBubble(text: "얼마나 자주 데이트를 하고 싶어?")
      .padding()
  }
  
}
