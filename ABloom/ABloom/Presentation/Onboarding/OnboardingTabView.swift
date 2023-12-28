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
    VStack(spacing: 0) {
      
      tabIndicator
        .padding(.vertical, 50)
      
      tabViews
      
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
          selectedTab = index
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
        title: "수백개의 다양한 질문들,",
        subtitle: "둘러보고 골라보세요",
        imageName: "onboarding_1"
      )
      .tag(0)
      
      OnboardingPageView(
        title: "나의 생각을 정리해가며",
        subtitle: "답변을 작성해보세요",
        imageName: "onboarding_2"
      )
      .tag(1)
      
      OnboardingPageView(
        title: "서로의 생각을 확인하고",
        subtitle: "반응을 남겨보세요",
        imageName: "onboarding_3"
      )
      .tag(2)
    }
    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
  }
  
  private var startButton: some View {
    return Button(
      action: { 
        isFirstLaunching.toggle()
        MixpanelManager.signUpStart(pageNum: selectedTab)
      },
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
          .padding(0)
      }
    )
  }
}

#Preview {
  OnboardingTabView(isFirstLaunching: .constant(false))
}
