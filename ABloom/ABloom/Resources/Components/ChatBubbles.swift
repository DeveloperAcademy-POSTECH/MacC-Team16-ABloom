//
//  ChatBubbleComponents.swift
//  ABloom
//
//  Created by yun on 10/19/23.
//

import SwiftUI

// Customized Chat Bubbles

private let paddingV = 10.0
private let paddingH = 12.0
private let cornerV = 12.0

struct LeftGrayChatBubble: View {
  let text: String
  
  var body: some View {
    HStack {
      
      Text(text)
        .fontWithTracking(.chatBubble, tracking: -0.2, lineSpacing: 7)
        .foregroundStyle(.stone800)
        .padding(.vertical, paddingV)
        .padding(.horizontal, paddingH)
        .multilineTextAlignment(.leading)
      
        .background(
          Rectangle()
            .clayMorpMDShadow()
            .foregroundStyle(.purple50)
            .cornerRadius(cornerV, corners: [.topRight, .bottomRight, .bottomLeft])
        )
        .frame(maxWidth: 247, alignment: .leading)
      
      Spacer()
    }
  }
}

struct RightPurpleChatBubble: View {
  let text: String
  
  var body: some View {
    HStack {
      Spacer()
      
      Text(text)
        .fontWithTracking(.chatBubble, tracking: -0.2, lineSpacing: 7)
        .foregroundStyle(.stone800)
        .multilineTextAlignment(.leading)
        .padding(.vertical, paddingV)
        .padding(.horizontal, paddingH)
        .background(
          Rectangle()
            .clayMorpMDShadow()
            .foregroundStyle(.purple300)
            .cornerRadius(cornerV, corners: [.topLeft, .bottomRight, .bottomLeft])
        )
        .frame(maxWidth: 247, alignment: .trailing)
    }
  }
}

// MARK: - PurpleQuestionChat

struct QuestionChatBubble: View {
  let text: String
  
  var body: some View {
    HStack {
      
      Text(text)
        .fontWithTracking(.chatBubble, tracking: -0.2, lineSpacing: 7)
        .fixedSize(horizontal: false, vertical: true)
        .foregroundStyle(.stone800)
        .multilineTextAlignment(.leading)
        .padding(.vertical, paddingV)
        .padding(.horizontal, paddingH)
       
        .background(
          Rectangle()
            .clayMorpMDShadow()
            .foregroundStyle(.purple300)
            .cornerRadius(cornerV, corners: [.topRight, .bottomRight, .bottomLeft])
        )
        .frame(minHeight: 41, alignment: .center)
        .frame(maxWidth: 271, alignment: .leading)
      Spacer()
    }
  }
  
}

// MARK: - ChatBubbleBtn

struct ChatBubbleBtn: View {
  let text: String
  let disabled: Bool
  
  init(text: String) {
    self.text = text
    self.disabled = false
  }
  
  init(text: String, disabled: Bool) {
    self.text = text
    self.disabled = disabled
  }
  
  var body: some View {
    HStack {
      Spacer()
      
      Text(text)
        .fontWithTracking(.chatBubbleBtn, tracking: -0.2, lineSpacing: 7)
        .foregroundStyle(.stone800)
        .multilineTextAlignment(.leading)
        .padding(.vertical, paddingV)
        .padding(.horizontal, paddingH)
        .background(
          Rectangle()
            .clayMorpMDShadow()
            .foregroundStyle(.purple300)
            .overlay {
              disabled ? Color.black.opacity(0.18) : Color.clear
            }
            .cornerRadius(cornerV, corners: [.topLeft, .bottomRight, .bottomLeft])
        )
        .frame(maxWidth: 247, alignment: .trailing)
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
      LeftGrayChatBubble(text: text)
    }
  }
}

// MARK: - TextField ChatBubbles

struct ChatBubbleTextField: View {
  @Binding var text: String
  
  var body: some View {
    
    TextField("", text: $text, axis: .vertical)
      .placeholder(when: text.isEmpty, placeholder: {
        Text("답변을 작성해주세요. (150자 이내)")
          .font(.custom("SpoqaHanSansNeo-Regular", size: 14))
          .tracking(-0.2)
          .lineSpacing(7)
          .foregroundStyle(.stone300)
      })
      .font(.custom("SpoqaHanSansNeo-Regular", size: 14))
      .tracking(-0.2)
      .lineSpacing(7)
      .foregroundStyle(.white)
      .multilineTextAlignment(.leading)
    
      .padding(.vertical, paddingV)
      .padding(.horizontal, paddingH)
      .background(
        Rectangle()
          .clayMorpMDShadow()
          .foregroundStyle(.purple600)
          .cornerRadius(cornerV, corners: [.topLeft, .bottomRight, .bottomLeft])
      )
      .frame(minHeight: 20, alignment: .center)
      .frame(maxWidth: 247, alignment: .leading)
  }
}

// MARK: - Chat Callout

struct ChatCallout: View {
  let text: String
  
  var body: some View {
    Text(text)
      .fontWithTracking(.caption2R, tracking: -0.4)
      .foregroundStyle(.white)
      .padding(.vertical, 7)
      .padding(.horizontal, 14)
      .background(
        RoundedRectangle(cornerRadius: 24)
          .foregroundStyle(.black.opacity(0.3))
      )
  }
}



#Preview {
  Group {
    LeftGrayChatBubble(text: "내용을 입력해주세요.")
    RightPurpleChatBubble(text: "내용을 입력해주세요.")
    ChatCallout(text: "내용")
    
  }
}
