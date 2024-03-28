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
  @State var showSensitiveInfo = false
  
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
    VStack(alignment: .leading) {
      Spacer()
      
      Button {
        signUpViewModel.checkAllAgreement()
      } label: {
        HStack(spacing: 10) {
          Image(systemName: "checkmark.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 23)
            .foregroundStyle(signUpViewModel.isAllChecked ? .primary60 : .gray300)
          
          Text("전체 동의")
            .font(.title3B)
            .foregroundStyle(.gray950)
        }
      }
      .padding(.bottom, 32)
      
      AgreementCheckButton(title: "만 14세 이상", hasContract: false, isActive: signUpViewModel.isCheckedOverFourteen) {
        signUpViewModel.isCheckedOverFourteen.toggle()
      }
        .padding(.bottom, 30)
      
      AgreementCheckButton(title: "서비스 이용약관", isActive: signUpViewModel.isCheckedTermsOfuse) {
        signUpViewModel.isCheckedTermsOfuse.toggle()
      } webButtonAction: {
        showTermOfUse = true
      }
        .padding(.bottom, 30)
      
      AgreementCheckButton(title: "민감정보 수집 동의", isActive: signUpViewModel.isCheckedSensitiveInfo) {
        signUpViewModel.isCheckedSensitiveInfo.toggle()
      } webButtonAction: {
        showSensitiveInfo = true
      }
        .padding(.bottom, 30)
      
      AgreementCheckButton(title: "개인정보 처리방침", isActive: signUpViewModel.isCheckedPrivacyPolicy) {
        signUpViewModel.isCheckedPrivacyPolicy.toggle()
      } webButtonAction: {
        showPrivacyPolicy = true
      }
        .padding(.bottom, 48)
      
      Button {
        signUpViewModel.stepToNext()
      } label: {
        Text("동의하고 가입하기")
          .customFont(.calloutB)
          .foregroundStyle(.white)
          .frame(height: 56)
          .frame(maxWidth: .infinity)
          .background(signUpViewModel.isAllChecked ? Color.primary80 : .gray400)
          .cornerRadius(8, corners: .allCorners)
      }
      .padding(.bottom, 55)
      .disabled(!signUpViewModel.isAllChecked)
    }
    
    .sheet(isPresented: $showPrivacyPolicy, content: {
      EmbedWebView(viewTitle: "개인정보 처리 방침", urlString: ServiceWebURL.privacyPolicy.rawValue, type: .sheet, showSheet: $showPrivacyPolicy, checkContract: $signUpViewModel.isCheckedPrivacyPolicy)
    })

    .sheet(isPresented: $showTermOfUse, content: {
      EmbedWebView(viewTitle: "서비스 이용약관", urlString: ServiceWebURL.termsOfuse.rawValue, type: .sheet, showSheet: $showTermOfUse, checkContract: $signUpViewModel.isCheckedTermsOfuse)
    })
    
    .sheet(isPresented: $showSensitiveInfo, content: {
      EmbedWebView(viewTitle: "민감정보 수집 동의", urlString: ServiceWebURL.sensitiveInfo.rawValue, type: .sheet, showSheet: $showSensitiveInfo, checkContract: $signUpViewModel.isCheckedSensitiveInfo)
    })
  }
  
  struct AgreementCheckButton: View {
    let title: String
    var hasContract: Bool = true
    var isActive: Bool
    
    var checkButtonAction: () -> Void
    var webButtonAction: (() -> Void)?
    
    var body: some View {
      HStack(spacing: 8) {
        Button {
          checkButtonAction()
        } label: {
          Image(systemName: "checkmark")
            .resizable()
            .frame(width: 13, height: 8)
            .foregroundStyle(isActive ? .primary60 : .gray300)
            .frame(width: 28, height: 28)
        }
        
        Text("[필수] \(title)")
          .font(.subHeadlineR)
          .foregroundStyle(.gray900)
        
        Spacer()
        
        if hasContract {
          Button {
            webButtonAction?()
          } label: {
            Text("보기")
              .font(.subHeadlineR)
              .foregroundStyle(.gray900)
          }
        }
      }
    }
  }
}
