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
  
  init() {
    UITabBar.appearance().backgroundColor = UIColor.white
  }
  
  var body: some View {
    TabView(selection: $selectedTab) {
      ForEach(Tab.allCases, id: \.self) { tab in
        switch tab {
        case .main:
          HomeView()
            .tabItem {
              Image(systemName: tab.icon)
              Text(tab.title)
            }
            .tag(tab)
        case .qna:
          Text("QNA")
            .tabItem {
              Image(systemName: tab.icon)
              Text(tab.title)
            }
            .tag(tab)
        case .info:
          MenuView()
            .tabItem {
              Image(systemName: tab.icon)
              Text(tab.title)
            }
            .tag(tab)
        }
      }
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

#Preview {
  TabBarView()
}
