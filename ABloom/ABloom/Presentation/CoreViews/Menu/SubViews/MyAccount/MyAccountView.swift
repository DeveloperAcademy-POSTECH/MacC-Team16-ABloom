//
//  MyAccountView.swift
//  ABloom
//
//  Created by 정승균 on 10/22/23.
//

import SwiftUI

struct MyAccountView: View {
  let avatarSize: CGFloat = 70
  @Environment(\.dismiss) private var dismiss

  @StateObject var myAccountVM = MyAccountViewModel()
  @State var showLoginView = false
  
  var body: some View {
    
    VStack(alignment: .center) {
      if myAccountVM.isReady {
        userInfo
          .padding(.bottom, 50)
          .padding(.top, 40)
      } else {
        ProgressView()
      }
        accountMenuList
        
        Spacer()
    }
    .task {
      try? await myAccountVM.getMyInfo()
    }
    .tint(.purple600)
    .padding(.horizontal, 25)
    .confirmationDialog("정보 변경", isPresented: $myAccountVM.showActionSheet, titleVisibility: .hidden) {
      Button("이름 변경하기", role: .none) {
        myAccountVM.showNameChangeAlert = true
      }
      
      Button("결혼예정일 수정하기", role: .none) {
        myAccountVM.showDatePicker = true
      }
      
      Button("취소", role: .cancel) {
        myAccountVM.showActionSheet = false
      }
    }
    .customNavigationBar {
      Text("내 계정")
    } leftView: {
      Button {
        dismiss()
      } label: {
        NavigationArrowLeft()
      }
    } rightView: {
      EmptyView()
    }
    .background(backgroundDefault())
    .fullScreenCover(isPresented: $showLoginView, content: {
      NavigationStack {
        LoginView(showLoginView: $showLoginView)
      }
    })
  }
}

#Preview {
  NavigationView {
    MyAccountView()
  }
}

extension MyAccountView {
  private var userInfo: some View {
    HStack(spacing: 15) {
      Image("avatar_Female circle GradientBG")
        .resizable()
        .scaledToFit()
        .frame(width: avatarSize)
      
      VStack(alignment: .leading) {
        Text(myAccountVM.userName ?? "정보 없음")
          .fontWithTracking(.title3Bold)
          .foregroundStyle(.stone800)
        HStack {
          Text(myAccountVM.dDayText)
          Spacer()
          
          Button {
            myAccountVM.showActionSheet = true
          } label: {
            Text("정보 수정하기 >")
          }
        }
        .fontWithTracking(.footnoteR)
        .foregroundStyle(.stone500)
      }
    }
    // 이름 변경 Alert
    .alert("이름 변경하기", isPresented: $myAccountVM.showNameChangeAlert) {
      // TODO: 버튼 UI 수정
      TextField(text: $myAccountVM.nameChangeTextfield) {
        Text("홍길동")
      }
      
      Button {
        myAccountVM.showNameChangeAlert = false
      } label: {
        Text("취소")
      }
      
      Button("확인") {
        Task {
          try? myAccountVM.updateMyName(name: myAccountVM.nameChangeTextfield)
          try? await myAccountVM.getMyInfo()
        }
      }
    } message: {
      Text("변경할 이름을 입력해주세요.")
    }
    // 결혼 날짜 변경 모달
    .sheet(isPresented: $myAccountVM.showDatePicker) {
      DatePicker("", selection: $myAccountVM.marriageDate, displayedComponents: .date)
        .datePickerStyle(.graphical)
        .frame(width: 320)
        .labelsHidden()
        .presentationDetents([.medium])
      
      Button {
        Task {
          try? myAccountVM.updateMyMarriageDate(date: myAccountVM.marriageDate)
          try? await myAccountVM.getMyInfo()
          myAccountVM.showDatePicker = false
        }
      } label: {
        Text("완료")
      }
    }
  }
  
  private var accountMenuList: some View {
    VStack(alignment: .leading, spacing: 30) {
      Text("내 계정 관리")
        .fontWithTracking(.headlineBold)
      
      MenuListButtonItem(title: "로그아웃") {
        myAccountVM.showSignOutCheckAlert = true
      }
      
      MenuListNavigationItem(title: "회원탈퇴") {
        DeleteAccountView()
      }
    }
    .alert("로그아웃 하시겠어요?", isPresented: $myAccountVM.showSignOutCheckAlert) {
      // TODO: 버튼 UI 수정
      Button("취소") {
        myAccountVM.showSignOutCheckAlert = false
      }
      
      Button("로그아웃") {
        try? myAccountVM.signOut()
        showLoginView = true
        myAccountVM.showSignOutCheckAlert = false
      }
    } message: {
      Text("다시 로그인해도 정보가 유지되니\n안심하고 로그아웃하셔도 돼요.")
    }
  }
}
