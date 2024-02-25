//
//  SignUpContentView.swift
//  ABloom
//
//  Created by 정승균 on 11/17/23.
//

import SwiftUI

struct SignUpContentView: View {
  @ObservedObject var signUpViewModel: SignUpViewModel
  let step: SignUpStep
  @State var showPrivacyPolicy = false
  @State var showTermOfUse = false
  
  var body: some View {
    VStack(alignment: .leading) {
      headlineText
        .padding(.bottom, 12)
      
      subHeadlineText
        .padding(.bottom, 50)
      
      switch step {
      case .step1:
        selectSex
      case .step2:
        datePicker
      case .step3:
        nameTextField
      case .step4:
        confirmContract
      }
      
      Spacer()
    }
  }
}

#Preview {
  SignUpContentView(signUpViewModel: SignUpViewModel(), step: .step4)
}

extension SignUpContentView {
  private var headlineText: some View {
    Text(step.headlineText)
      .customFont(.title2B)
      .foregroundStyle(.gray900)
  }
  
  private var subHeadlineText: some View {
    Text(step.subHeadlineText)
      .foregroundStyle(.gray700)
  }
  
  private var selectSex: some View {
    VStack(spacing: 12) {
      Button {
        withAnimation {
          signUpViewModel.selectedSex = .man
          signUpViewModel.nowStep = .step2
          MixpanelManager.signUpSexType(type: signUpViewModel.selectedSex)
        }
      } label: {
        ButtonWDescriptionA(title: "예비신랑", subtitle: "결혼을 준비하는 예비신랑이에요.", isActive: signUpViewModel.selectedSex == .man)
      }
      .frame(maxWidth: .infinity)
      
      Button {
        withAnimation {
          signUpViewModel.selectedSex = .woman
          signUpViewModel.nowStep = .step2
          MixpanelManager.signUpSexType(type: signUpViewModel.selectedSex)
        }
      } label: {
        ButtonWDescriptionA(title: "예비신부", subtitle: "결혼을 준비하는 예비신부예요.", isActive: signUpViewModel.selectedSex == .woman)
      }
      .frame(maxWidth: .infinity)
    }
  }
  
  private var datePicker: some View {
    DatePicker("", selection: $signUpViewModel.selectedDate, displayedComponents: .date)
      .datePickerStyle(.wheel)
      .labelsHidden()
  }
  
  private var nameTextField: some View {
    TextField("", text: $signUpViewModel.inputName)
      .placeholder(when: signUpViewModel.inputName.isEmpty) {
        Text("이름을 입력해주세요.")
          .customFont(.headlineR)
          .foregroundStyle(.gray500)
      }
      .frame(height: 27)
      .customFont(.headlineR)
      .padding(.vertical, 20)
      .padding(.horizontal, 22)
      .background(Color.gray100)
      .cornerRadius(12, corners: .allCorners)
  }
  
  private var confirmContract: some View {
    VStack(spacing: 12) {
      Button {
        showPrivacyPolicy = true
      } label: {
        ButtonWDescriptionB(title: "개인정보 처리방침", subtitle: "확인하기", isActive: signUpViewModel.isCheckedPrivacyPolicy)
      }
      
      Button {
        showTermOfUse = true
      } label: {
        ButtonWDescriptionB(title: "서비스 이용약관", subtitle: "확인하기", isActive: signUpViewModel.isCheckedTermsOfuse)
      }
      
      Button {
        signUpViewModel.isCheckedOverFourteen.toggle()
      } label: {
        ButtonWDescriptionB(title: "만 14세 이상입니다.", subtitle: "동의하기", isActive: signUpViewModel.isCheckedOverFourteen)
      }
    }
    .frame(maxWidth: .infinity)
    
    .sheet(isPresented: $showPrivacyPolicy, content: {
      EmbedWebView(viewTitle: "개인정보 처리방침", urlString: ServiceWebURL.privacyPolicy.rawValue, type: .sheet, showSheet: $showPrivacyPolicy, checkContract: $signUpViewModel.isCheckedPrivacyPolicy)
    })
    
    .sheet(isPresented: $showTermOfUse, content: {
      EmbedWebView(viewTitle: "서비스 이용약관", urlString: ServiceWebURL.termsOfuse.rawValue, type: .sheet, showSheet: $showTermOfUse, checkContract: $signUpViewModel.isCheckedTermsOfuse)
    })
  }
}
