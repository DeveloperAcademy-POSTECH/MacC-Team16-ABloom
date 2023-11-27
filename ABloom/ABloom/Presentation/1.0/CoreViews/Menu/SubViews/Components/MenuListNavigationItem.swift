//
//  MenuListItem.swift
//  ABloom
//
//  Created by 정승균 on 10/22/23.
//

import SwiftUI

struct MenuListNavigationItem<Content: View>: View {
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
          .fontWithTracking(.subHeadlineB)
          .foregroundStyle(.stone800)
        
        Spacer()
        
        Text(subContent)
          .foregroundStyle(.pink600)
          .fontWithTracking(.caption1R)
          .padding(.trailing, 7.15)
        
        Image(systemName: "chevron.right")
          .foregroundStyle(.stone400)
          .bold()
      }
    }
  }
}

struct MenuListButtonItem: View {
  let title: String
  let subContent: String
  let action: () -> Void
  
  init(title: String, subContent: String = "", action: @escaping () -> Void) {
    self.title = title
    self.subContent = subContent
    self.action = action
  }
  
  var body: some View {
    Button(action: action, label: {
      HStack {
        Text(title)
          .fontWithTracking(.subHeadlineB)
          .foregroundStyle(.stone800)
        
        Spacer()
        
        Text(subContent)
          .foregroundStyle(.pink600)
          .fontWithTracking(.caption1R)
          .padding(.trailing, 7.15)
        
        Image(systemName: "chevron.right")
          .foregroundStyle(.stone400)
          .bold()
      }
    })
  }
}
