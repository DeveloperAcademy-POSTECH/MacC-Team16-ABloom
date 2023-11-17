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
  
  var body: some View {
    VStack(alignment: .leading) {
      progressBar
        .padding(.top, 20)
        .padding(.bottom, 30)
      
      SignUpContentView(signUpViewModel: vm, step: .step1)
      
      Spacer()
    }
    .padding(.horizontal, horizontalPadding)
    .toolbar {
      ToolbarItem(placement: .cancellationAction) {
        Button("취소") {
          // Sheet 닫기
        }
      }
      ToolbarItem(placement: .principal) {
        Text("가입하기")
      }
    }
  }
}

#Preview {
  NavigationStack {
    SignUpView()
  }
}

extension SignUpView {
  private var progressBar: some View {
    ZStack {
      Rectangle()
        .foregroundColor(.clear)
        .frame(height: 6)
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.88, green: 0.89, blue: 0.91))
        .cornerRadius(30)
      
      HStack {
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 87.5, height: 6)
          .background(Color(red: 0.6, green: 0.43, blue: 0.69))
          .cornerRadius(30)
        
        Spacer()
      }
    }
  }
  
  private var headlineText: some View {
    Text("가입 유형을 선택해주세요.")
  }
  
  private var subHeadlineText: some View {
    Text("가입 유형을 선택해주세요.")
  }
}
