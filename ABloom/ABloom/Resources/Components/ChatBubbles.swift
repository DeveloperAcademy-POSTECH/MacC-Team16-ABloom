//
//  ChatBubbleComponents.swift
//  ABloom
//
//  Created by yun on 10/19/23.
//

import SwiftUI

// Customized Chat Bubbles

let paddingV = 10.0

struct LeftBlueChatBubble: View {
  let text: String
  let isBold: Bool
  
  init(text: String) {
    self.text = text
    self.isBold = false
  }
  
  init(text: String, isBold: Bool) {
    self.text = text
    self.isBold = isBold
  }
  
  var body: some View {
    HStack {
      Spacer()
      
      Text(text)
        .fontWithTracking(isBold ? .footnoteBold : .footnoteR, tracking: -0.4)
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

struct LeftPinkChatBubble: View {
  let text: String
  let isBold: Bool
  
  init(text: String) {
    self.text = text
    self.isBold = false
  }
  
  init(text: String, isBold: Bool) {
    self.text = text
    self.isBold = isBold
  }
  
  var body: some View {
    HStack {
      Spacer()
      
      Text(text)
        .fontWithTracking(isBold ? .footnoteBold : .footnoteR, tracking: -0.4)
        .foregroundStyle(.stone900)
        .padding(paddingV)
        .background(
          Rectangle()
            .foregroundStyle(.pink100)
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
  let isBold: Bool
  
  init(text: String) {
    self.text = text
    self.isBold = false
  }
  
  init(text: String, isBold: Bool) {
    self.text = text
    self.isBold = isBold
  }
  
  var body: some View {
    HStack {
      Spacer()
      
      Text(text)
        .fontWithTracking(isBold ? .footnoteBold : .footnoteR, tracking: -0.4)
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

struct RightPinkChatBubble: View {
  let text: String
  let isBold: Bool
  
  init(text: String) {
    self.text = text
    self.isBold = false
  }
  
  init(text: String, isBold: Bool) {
    self.text = text
    self.isBold = isBold
  }
  
  
  var body: some View {
    HStack {
      Spacer()
      
      Text(text)
        .fontWithTracking(isBold ? .footnoteBold : .footnoteR, tracking: -0.4)
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

// MARK: - ChatBubbles with Imgs

struct LeftPinkChatBubbleWithImg: View {
  let text: String
  
  var body: some View {
    HStack(alignment: .top, spacing: 13) {
      Image("avatar_Female circle GradientBG")
        .resizable()
        .frame(width: 34, height: 34)
      LeftPinkChatBubble(text: text)
    }
  }
}

struct LeftBlueChatBubbleWithImg: View {
  let text: String
  
  var body: some View {
    HStack(alignment: .top, spacing: 13) {
      Image("avatar_Male circle GradientBG")
        .resizable()
        .frame(width: 34, height: 34)
      LeftBlueChatBubble(text: text)
    }
  }
}

// MARK: -TextField ChatBubbles

struct BlueChatBubbleTextField: View {
  @Binding var text: String
  
  var body: some View {
    
    TextField("", text: $text, axis: .vertical)
      .placeholder(when: text.isEmpty, placeholder: {
        Text("답변을 작성해주세요. (150자 이내)")
          .font(.custom("SpoqaHanSansNeo-Regular", size: 12))
          .tracking(-0.4)
          .foregroundStyle(.stone300)
      })
    
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
    
    TextField("", text: $text, axis: .vertical)
      .placeholder(when: text.isEmpty, placeholder: {
        Text("답변을 작성해주세요. (150자 이내)")
          .font(.custom("SpoqaHanSansNeo-Regular", size: 12))
          .tracking(-0.4)
          .foregroundStyle(.stone300)
      })
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
