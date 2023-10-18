//
//  HomeView.swift
//  ABloom
//
//  Created by yun on 10/11/23.
//

import SwiftUI

struct HomeView: View {
  var body: some View {
    return ZStack {
      Text("Hello ABloom 화이팅 :)")
        .fontWithTracking(fontStyle: .title1Bold)
    }
  }
}

#Preview {
  HomeView()
}
