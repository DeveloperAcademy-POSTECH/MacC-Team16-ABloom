//
//  MainView.swift
//  ABloom
//
//  Created by yun on 10/11/23.
//

// Example MainView in TCA

import ComposableArchitecture
import SwiftUI

struct MainView: View {
  // Connecting MainViewFeature with MainView
  // viewStore로 감싸는 것보다 ObservedObject로 처리하는 것이 하나의 indentation이 줄어들어 효율적
  let store: StoreOf<MainViewFeature>

  @ObservedObject private var viewStore: ViewStoreOf<MainViewFeature>

  public init(store: StoreOf<MainViewFeature>) {
    self.store = store
    viewStore = ViewStore(store, observe: {$0})
  }

  var body: some View {
    ZStack {
      Button {
        viewStore.send(.helloButtonTapped)
      } label: {
        Text("Hello")
      }
    }
    .sheet(isPresented: viewStore.$isTextOn, content: {
      Text("Hello")
    })
  }
}

#Preview {
  MainView(
    store: Store(initialState: MainViewFeature.State()) {
      MainViewFeature()
    }
  )
}
