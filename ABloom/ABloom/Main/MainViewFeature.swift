//
//  MainViewFeature.swift
//  ABloom
//
//  Created by yun on 10/11/23.
//

import ComposableArchitecture
import SwiftUI

struct MainViewFeature: Reducer {
  struct State: Equatable {
    var text: String = "hello"
    @BindingState var isTextOn: Bool = false

  }
  enum Action: Equatable, BindableAction {
    case helloButtonTapped
    case binding(BindingAction<State>)

  }
  var body: some ReducerOf<Self> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .helloButtonTapped:
        state.isTextOn.toggle()
        return .none

      case .binding:
        return .none
      }
    }

  }
}
