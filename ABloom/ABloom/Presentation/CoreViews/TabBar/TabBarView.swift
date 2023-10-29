//
//  TabBarView.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/17/23.
//

import SwiftUI

struct TabBarView: View {
  @State var selectedTab: Tab = .main
  @State var showLoginView = false
  
  private let shadowWhite: ShadowStyle = ShadowStyle
    .inner(color: .white, radius: 7, x: 3, y: 1)
  private let shadowBlack: ShadowStyle = ShadowStyle
    .inner(color: .black.opacity(0.1), radius: 5, x: 0, y: -3)
  
  init() {
    UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .purple500
  }
  
  var body: some View {
    NavigationStack {
      ZStack(alignment: .bottom) {
        TabView(selection: $selectedTab) {
          ForEach(Tab.allCases, id: \.self) { tab in
            switch tab {
            case .main:
              HomeView()
                .tag(tab)
            case .qna:
              QuestionMainView()
                .tag(tab)
            case .info:
              MenuView()
                .tag(tab)
            }
          }
        }
        
        customTabBar
      }
      .ignoresSafeArea()
    }
    
    .onAppear {
      let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
      self.showLoginView = authUser == nil
    }
    .fullScreenCover(isPresented: $showLoginView, content: {
      NavigationStack {
        LoginView(showLoginView: $showLoginView)
      }
    })
  }
}

extension TabBarView {
  private var customTabBar: some View {
    VStack {
      HStack(spacing: 90) {
        ForEach(Tab.allCases, id: \.self) { item in
          Button {
            selectedTab = item
          } label: {
            customTabItem(
              imageName: item.image,
              title: item.title,
              isActive: (selectedTab == item))
          }
        }
      }
      
      Rectangle()
        .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 0 : 20)
        .foregroundStyle(.white)
    }
    .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 80 : 112)
    .frame(maxWidth: .infinity)
    .background(.white)
    .cornerRadius(32, corners: [.topLeft, .topRight])
    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 7)
  }
  
  func customTabItem(imageName: String, title: String, isActive: Bool) -> some View {
    VStack(spacing: 4) {
      
      if isActive {
        RoundedRectangle(cornerRadius: 3)
          .foregroundStyle(
            purpleGradient65()
              .shadow(shadowWhite)
              .shadow(shadowBlack)
          )
          .frame(width: 28, height: 5)
        
        Rectangle()
          .foregroundStyle(
            purpleGradient65()
              .shadow(shadowWhite)
              .shadow(shadowBlack)
          )
          .mask {
            tabImage(imageName)
          }
      }
      
      else {
        Spacer()
        
        Color.stone400
          .mask {
            tabImage(imageName)
          }
      }
      
    }
    .frame(width: 28, height: 36)
  }
  
  func tabImage(_ imageName: String) -> some View {
    return Image(imageName)
      .resizable()
      .frame(width: 27, height: 27)
      .scaledToFit()
  }
}

#Preview {
  TabBarView()
}
