//
//  ConnectedView.swift
//  ABloom
//
//  Created by 정승균 on 11/22/23.
//

import SwiftUI

struct ConnectedView: View {
  var body: some View {
    VStack {
      Image(systemName: "circle.fill")
        .resizable()
        .scaledToFit()
        .padding(.horizontal, 100)
        .padding(.bottom, 31)
    }
  }
}

#Preview {
  ConnectedView()
}
