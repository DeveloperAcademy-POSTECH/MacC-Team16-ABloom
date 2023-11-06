//
//  ChatBubbleComponents.swift
//  ABloom
//
//  Created by yun on 10/19/23.
//

import SwiftUI

// Customized Chat Bubbles

let paddingV = 10.0

struct LeftChatBubble: View {
  let text: String
  let isBold: Bool
  let isMale: Bool
  
  init(text: String, isBold: Bool, isMale: Bool) {
    self.text = text
    self.isBold = isBold
    self.isMale = isMale
  }
  
  init(text: String, isMale: Bool) {
    self.text = text
    self.isBold = false
    self.isMale = isMale
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
            .foregroundStyle(isMale ? .blue100 : .pink100)
            .cornerRadius(10, corners: [.topRight, .bottomRight, .bottomLeft])
        )
        .frame(minHeight: 20, alignment: .center)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      Spacer()
    }
  }
}

struct RightChatBubble: View {
  let text: String
  let isBold: Bool
  let isMale: Bool
  
  init(text: String, isBold: Bool, isMale: Bool) {
    self.text = text
    self.isBold = isBold
    self.isMale = isMale
  }
  
  init(text: String, isMale: Bool) {
    self.text = text
    self.isBold = false
    self.isMale = isMale
  }
  
  var body: some View {
    HStack {
      Spacer()
      
      Text(text)
        .fontWithTracking(isBold ? .footnoteBold : .footnoteR, tracking: -0.4)
        .foregroundStyle(.stone900)
        .multilineTextAlignment(.leading)
        .padding(paddingV)
        .background(
          Rectangle()
            .foregroundStyle(self.isMale ? .blue100 : .pink100)
            .cornerRadius(10, corners: [.topLeft, .bottomRight, .bottomLeft])
        )
        .frame(minHeight: 16, alignment: .center)
        .frame(maxWidth: 270, alignment: .trailing)
    }
  }
}

// MARK: - ChatBubbles with Imgs

struct LeftChatBubbleWithImg: View {
  let text: String
  let isMale: Bool
  
  var body: some View {
    HStack(alignment: .top, spacing: 6) {
      Image(isMale ? "avatar_Male circle GradientBG" : "avatar_Female circle GradientBG")
        .resizable()
        .frame(width: 34, height: 34)
      LeftChatBubble(text: text, isMale: self.isMale)
    }
  }
}

// MARK: - TextField ChatBubbles

struct ChatBubbleTextField: View {
  @Binding var text: String
  let isMale: Bool
  
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
          .foregroundStyle(self.isMale ? .blue500 : .pink500)
          .cornerRadius(10, corners: [.topLeft, .bottomRight, .bottomLeft])
      )
      .frame(minHeight: 30, alignment: .center)
      .frame(width: 242, alignment: .center)
  }
}
