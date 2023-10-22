//
//  MenuListItem.swift
//  ABloom
//
//  Created by 정승균 on 10/22/23.
//

import SwiftUI

struct MenuListItem<Content: View>: View {
  let title: String
  let subContent: String
  let destination: Content
  
  init(title: String, subContent: String = "", @ViewBuilder destination: () -> Content) {
    self.title = title
    self.subContent = subContent
    self.destination = destination()
  }
  
  var body: some View {
    NavigationLink {
      destination
    } label: {
      HStack {
        Text(title)
          .fontWithTracking(fontStyle: .subHeadlineBold)
          .foregroundStyle(.stone800)
        
        Spacer()
        
        Text(subContent)
          .foregroundStyle(.pink600)
          .fontWithTracking(fontStyle: .caption1R)
          .padding(.trailing, 7.15)
        
        Image(systemName: "chevron.right")
          .foregroundStyle(.stone400)
          .bold()
      }
    }
  }
}
