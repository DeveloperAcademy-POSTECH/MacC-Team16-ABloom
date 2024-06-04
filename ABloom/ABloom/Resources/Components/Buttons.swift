//
//  ButtomComponents.swift
//  ABloom
//
//  Created by yun on 10/18/23.
//

import SwiftUI

/// Apple Login Button Label
struct AppleLoginButton: View {
  var body: some View {
    HStack {
      Image(systemName: "apple.logo")
      Text("Apple로 계속하기")
    }
    .font(.custom("SFProDisplay-Regular", size: 16))
    .tracking(1)
    .foregroundStyle(.white)
    .background(
      RoundedRectangle(cornerRadius: 8)
        .frame(width: 350, height: 56)
    )
  }
}

struct ButtonWDescriptionA: View {
  let title: String
  let subtitle: String
  var isActive: Bool
  
  var body: some View {
    HStack {
      Text(title)
        .customFont(.calloutB)
        .foregroundStyle(.gray800)
        .padding(.trailing, 24)
      
      Text(subtitle)
        .customFont(.caption2R)
        .foregroundStyle(.gray600)
      
      Spacer()
    }
    .padding(.horizontal, 24)
    .padding(.vertical, 20)
    .background(isActive ? Color.primary10 : Color.gray100)
    .cornerRadius(12, corners: .allCorners)
    .overlay {
      RoundedRectangle(cornerRadius: 12)
        .inset(by: 0.75)
        .stroke(Color.primary40.opacity(isActive ? 1.0 : 0))
    }
  }
}

struct ButtonWDescriptionB: View {
  let title: String
  let subtitle: String
  var isActive: Bool
  
  var body: some View {
    HStack {
      Text(title)
        .customFont(.calloutB)
        .foregroundStyle(.gray800)
        .padding(.trailing, 24)
      
      Spacer()
      
      Text(subtitle)
        .customFont(.caption2R)
        .foregroundStyle(.gray500)
    }
    .padding(.horizontal, 25)
    .padding(.vertical, 20)
    .background(isActive ? Color.primary10 : Color.gray100)
    .cornerRadius(12, corners: .allCorners)
    .overlay {
      RoundedRectangle(cornerRadius: 12)
        .inset(by: 0.75)
        .stroke(Color.primary40.opacity(isActive ? 1.0 : 0))
    }
  }
}

struct PurpleTextButton: View {
  let title: String
  var isDisable: Bool = false
  
  var body: some View {
    Text(title)
      .customFont(.calloutB)
      .foregroundStyle(.gray50)
      .frame(height: 46)
      .frame(maxWidth: .infinity)
      .background(isDisable ? .gray400 : Color.primary80)
      .cornerRadius(8, corners: .allCorners)
      .disabled(isDisable)
  }
}

struct ConnectionButton: View {
  var title: String
  var color: Color
  var image: String
  var hasStroke = false
  
  var action: () -> Void
  
  var body: some View {
    Button {
      action()
    } label: {
      ZStack {
        RoundedRectangle(cornerRadius: 8)
          .foregroundStyle(color)
        
        HStack(spacing: 4) {
          Image(image)
            .renderingMode(.template)
          
          Text(title)
            .font(.bodyB)
        }
        .foregroundStyle(.gray950)
      }
    }
    .frame(height: 60)
    .overlay {
      if hasStroke {
        RoundedRectangle(cornerRadius: 8)
          .stroke()
          .foregroundStyle(.gray300)
      }
    }
  }
}

#Preview {
  ScrollView {
    ConnectionButton(title: "나의 연결 코드 복사하기", color: .yellow, image: "copy", action: {
      
    })
      .padding()
    
    PurpleTextButton(title: "ButtonWithText")
      .padding()

    ButtonWDescriptionA(title: "11", subtitle: "    11", isActive: false)
      .padding()
    
    ButtonWDescriptionB(title: "12312", subtitle: "123123", isActive: false)
      .padding()
  }
}
