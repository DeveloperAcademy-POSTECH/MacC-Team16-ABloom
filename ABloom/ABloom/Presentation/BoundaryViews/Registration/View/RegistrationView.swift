//
//  RegistrationView.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/17/23.
//

import SwiftUI

struct RegistrationView: View {
  @StateObject var registerVM = RegistrationViewModel()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 30) {
      Spacer().frame(height: 98)
      
      nameInputField
      
      typeInputField
      
      marriageDateInputField
      
      Spacer()
      
      nextButton
      
      Spacer().frame(height: 60)
    }
    .padding(.horizontal, 20)
    .background(backgroundDefault())
    .tint(.pink500)
    .ignoresSafeArea()
    .navigationTitle("가입하기")
    .navigationBarTitleDisplayMode(.inline)
  }
}

extension RegistrationView {
  private var nameInputField: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("이름")
        .fontWithTracking(fontStyle: .subHeadlineR)
      
      ZStack(alignment: .leading) {
        if !registerVM.isUserNameValid {
          Text("홍길동")
        }
        TextField("", text: $registerVM.userName)
          .foregroundStyle(.stone900)
      }
      .strokeInputFieldStyle(isValueValid: registerVM.isUserNameValid, alignment: .leading)
      .font(.calloutR).tracking(-0.4)
    }
  }
  
  private var typeInputField: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("가입유형")
        .fontWithTracking(fontStyle: .subHeadlineR)
      
      HStack(spacing: 18) {
        ForEach(UserType.allCases, id: \.self) { user in
          Button {
            registerVM.userType = user
          } label: {
            Text("\(user.rawValue)")
              .fontWithTracking(fontStyle: .calloutR, value: -0.4)
              .multilineTextAlignment(.center)
              .strokeInputFieldStyle(
                isValueValid: registerVM.isUserTypeValid(type: user),
                alignment: .center
              )
          }
        }
      }
    }
  }
  
  private var marriageDateInputField: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("결혼 예정일")
        .fontWithTracking(fontStyle: .subHeadlineR)
      
      Text("\(registerVM.formattedWeddingDate)")
        .fontWithTracking(fontStyle: .calloutR, value: -0.4)
        .strokeInputFieldStyle(isValueValid: registerVM.isWeddingDateValid, alignment: .leading)
        .onTapGesture {
          registerVM.isShowingDatePicker = true
        }
    }
    
    .sheet(isPresented: $registerVM.isShowingDatePicker) {
      DatePicker("", selection: $registerVM.weddingDate, displayedComponents: .date)
        .datePickerStyle(.graphical)
        .frame(width: 320)
        .labelsHidden()
        .presentationDetents([.medium])
      Button {
        registerVM.isDatePickerTapped = true
        registerVM.isShowingDatePicker = false
      } label: {
        Text("완료")
      }
    }
  }
  
  private var nextButton: some View {
    Button {
      // ConnectView()
      try? registerVM.registerNewUser()
    } label: {
      if registerVM.isNextButtonEnabled {
        PinkSingleBtn(text: "다음")
          .frame(maxWidth: .infinity)
      } else {
        StoneSingleBtn(text: "다음")
          .frame(maxWidth: .infinity)
      }
    }
    .disabled(!registerVM.isNextButtonEnabled)
    .navigationDestination(isPresented: $registerVM.isSuccessCreateUser) {
      ConnectionView()
    }
  }
}

#Preview {
  NavigationStack {
    RegistrationView()
  }
}
