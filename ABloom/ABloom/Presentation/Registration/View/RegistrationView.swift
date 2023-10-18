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
    VStack(alignment: .leading, spacing: 6) {
      
      Text("이름")
      TextField("홍길동", text: $registerVM.userName)
        .strokeInputFieldStyle(isValueValid: registerVM.isUserNameValid, alignment: .leading)
      
      Text("가입유형")
      HStack(spacing: 18) {
        ForEach(UserType.allCases, id: \.self) { user in
          Button {
            registerVM.userType = user
          } label: {
            Text("\(user.rawValue)")
              .multilineTextAlignment(.center)
              .strokeInputFieldStyle(
                isValueValid: registerVM.isUserTypeValid(type: user),
                alignment: .center
              )
          }
        }
      }
      
      Text("결혼 예정일")
      Text("\(registerVM.formattedWeddingDate)")
        .strokeInputFieldStyle(isValueValid: registerVM.isWeddingDateValid, alignment: .leading)
        .onTapGesture {
          registerVM.isDatePickerTapped = true
          registerVM.isShowingDatePicker = true
        }
      
      Button {
        print("Complete")
      } label: {
        Text("다음")
          .foregroundStyle(.white)
          .frame(width: 200, height: 40)
          .background(registerVM.isNextButtonEnabled ? Color.blue : Color.gray)
      }
      .disabled(!registerVM.isNextButtonEnabled)
    }
    .padding(.all, 20)
    .ignoresSafeArea()
    .sheet(isPresented: $registerVM.isShowingDatePicker) {
      DatePicker("", selection: $registerVM.weddingDate, displayedComponents: .date)
        .datePickerStyle(.graphical)
        .frame(width: 320)
        .labelsHidden()
      
      Button {
        registerVM.isShowingDatePicker = false
      } label: {
        Text("완료")
      }
    }
  }
}

#Preview {
  RegistrationView()
}
