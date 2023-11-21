//
//  SignUpView.swift
//  ABloom
//
//  Created by 정승균 on 11/15/23.
//

import SwiftUI

struct SignUpView: View {
  @StateObject var vm = SignUpViewModel()
  let horizontalPadding: CGFloat = 20
  
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    VStack(alignment: .leading) {
      progressBar
        .padding(.top, 20)
        .padding(.bottom, 30)

      SignUpContentView(signUpViewModel: vm, step: vm.nowStep)
      
      Spacer()
    }
    .padding(.horizontal, horizontalPadding)
    
    .onChange(of: vm.isSuccessCreateUser) { newValue in
      if newValue {
        dismiss()
      }
    }
    
    .customNavigationBar(centerView: {
      Text("가입하기")
        .customFont(.bodyB)
    }, leftView: {
      Button {
        if vm.nowStep == .step1 {
          
        } else {
          withAnimation {
            vm.stepToBack()
          }
        }
      } label: {
        if vm.nowStep == .step1 {
          Text("취소")
        } else {
          Image("angle-left")
            .resizable()
            .renderingMode(.template)
            .frame(width: 18, height: 18)
            .scaledToFit()
        }
      }
      .customFont(.calloutB)
      .foregroundStyle(Color.purple700)
    }, rightView: {
      Button(vm.nowStep == .step4 ? "완료": "다음") {
        withAnimation {
          vm.stepToNext()
        }
      }
      .customFont(.calloutB)
      .foregroundStyle(vm.nextButtonColor())
      .hidden(vm.nowStep == .step1)
      .disabled(vm.nextButtonDisableStatus())
    })
  }
}

#Preview {
  NavigationStack {
    SignUpView()
  }
}

extension SignUpView {
  private var progressBar: some View {
    ProgressView("", value: vm.nowStep.progress, total: 100)
      .labelsHidden()
      .tint(.purple600)
      .scaleEffect(y: 1.5)
  }
  
  private var headlineText: some View {
    Text("가입 유형을 선택해주세요.")
  }
  
  private var subHeadlineText: some View {
    Text("가입 유형을 선택해주세요.")
  }
}
