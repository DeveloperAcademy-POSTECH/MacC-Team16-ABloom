//
//  NavigationArrowLeft.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/30/23.
//

import SwiftUI

struct NavigationArrowLeft: View {
  var body: some View {
    Image("angle-left")
      .resizable()
      .renderingMode(.template)
      .scaledToFit()
      .frame(width: 18)
      .foregroundStyle(.purple700)
  }
}
