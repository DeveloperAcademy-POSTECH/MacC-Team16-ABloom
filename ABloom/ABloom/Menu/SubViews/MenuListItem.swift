//
//  MenuListItem.swift
//  ABloom
//
//  Created by 정승균 on 10/22/23.
//

import SwiftUI

struct MenuListItem<Content: View>: View {
  let title: String
  let destination: Content
  
  init(title: String, @ViewBuilder destination: () -> Content) {
    self.title = title
    self.destination = destination()
  }
  
  var body: some View {
    NavigationLink {
      destination
    } label: {
      HStack {
        Text(title)
          .font(.subHeadlineBold)
          .foregroundStyle(.stone800)
        
        Spacer()
        
        Image(systemName: "chevron.right")
          .foregroundStyle(.stone400)
          .bold()
      }
    }
  }
}
