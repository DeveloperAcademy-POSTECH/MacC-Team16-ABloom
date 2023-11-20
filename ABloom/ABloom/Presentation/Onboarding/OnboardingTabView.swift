//
//  OnboardingTabView.swift
//  ABloom
//
//  Created by yun on 11/18/23.
//

import SwiftUI

struct OnboardingTabView: View {
  
  @Binding var isFirstLaunching: Bool
  @State private var selectedTab = 0
  
  var body: some View {
    VStack {
      
      tabIndicator
        .padding(.vertical, 50)
      
      tabViews
        .frame(maxHeight: .infinity)
      
      startButton
      
    }
    .ignoresSafeArea(.all, edges: .bottom)
  }
}


extension OnboardingTabView {
  
  private var tabIndicator: some View {
    return HStack(spacing: 10) {
      ForEach(0..<3, id: \.self) { index in
        Button(action: {  withAnimation {
          selectedTab = index // Update selected tab
        } }, label: {
          Circle()
            .fill(selectedTab == index ? .purple600 : .gray300)
            .frame(width: 8, height: 8)
        })
      }
    }
  }
  
  private var tabViews: some View {
    return TabView(selection: $selectedTab) {
      
      OnboardingPageView(
        title: "동해물과 백두산이",
        subtitle: "마르고 닳도록",
        imageName: "person.3.fill"
      )
      .tag(0)
      
      OnboardingPageView(
        title: "쓰기 탭",
        subtitle: "이 앱은 개인 메모장으로도 쓸 수 있어요",
        imageName: "note.text.badge.plus"
      )
      .tag(1)
      
      OnboardingPageView(
        title: "쓰기 탭",
        subtitle: "이 앱은 개인 메모장으로도 쓸 수 있어요",
        imageName: "note.text.badge.plus"
      )
      .tag(2)
    }
    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
  }
  
  private var startButton: some View {
    return Button(
      action: { isFirstLaunching.toggle() },
      label: {
        Text("시작하기")
          .customFont(.title3B)
          .foregroundStyle(.white)
          .frame(maxWidth: .infinity)
          .padding(.bottom, 50)
          .padding(.top, 18)
          .background(
            Rectangle()
              .foregroundStyle(.purple700)
          )
      }
    )
  }
}
