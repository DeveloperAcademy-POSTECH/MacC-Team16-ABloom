//
//  ProfileMenuView.swift
//  ABloom
//
//  Created by 정승균 on 11/15/23.
//

import SwiftUI

struct ProfileMenuView: View {
  @Binding var showProfileMenuSheet: Bool
  @ObservedObject var activeSheet: ActiveSheet
  
  @StateObject var vm = ProfileMenuViewModel()
  
  var body: some View {
    ScrollView {
      VStack(spacing: 32) {
        VStack(alignment: .leading) {
          myInformation
            .padding(.bottom, 15)
          
          marriageDday
        }
        .padding(.horizontal, 20)
        
        menuSeparator
        
        manageMyAccount
        
        menuSeparator
        
        serviceUse
        
        menuSeparator
        
        exitAction
          .padding(.bottom, 85)
      }
      
    }
    .padding(.top, 27)
    
    .customNavigationBar {
      EmptyView()
    } leftView: {
      Button("취소") {
        showProfileMenuSheet = false
      }
      .customFont(.calloutB)
      .foregroundStyle(.purple700)
    } rightView: {
      EmptyView()
    }
    
    .ignoresSafeArea(.all, edges: .bottom)
    
    .confirmationDialog("", isPresented: $vm.showActionSheet, titleVisibility: .hidden) {
      Button("이름 변경하기") {
        vm.showNameChangeAlert = true
      }
      
      Button("결혼예정일 수정하기") {
        vm.showCalendarSheet = true
      }
    }
    
    // 이름 수정
    .alert("이름 변경하기", isPresented: $vm.showNameChangeAlert) {
      TextField(text: $vm.nameChangeTextfield) {
        Text("홍길동")
      }
      
      Button {
        vm.showNameChangeAlert = false
      } label: {
        Text("취소")
      }
      
      Button("확인") {
        Task {
          try? vm.updateMyName()
          try? await vm.renewInfo()
        }
      }
    } message: {
      Text("변경할 이름을 입력해주세요.")
    }
    
    // 결혼 일자 수정
    .sheet(isPresented: $vm.showCalendarSheet) {
      VStack {
        DatePicker("", selection: $vm.marriageDate, displayedComponents: .date)
          .datePickerStyle(.graphical)
          .frame(width: 320)
          .labelsHidden()
          .presentationDetents([.medium])
        
        Button {
          Task {
            try? vm.updateMyMarriageDate()
            try? await vm.renewInfo()
            vm.showActionSheet = false
          }
        } label: {
          Text("완료")
        }
      }
      .tint(.purple700)
    }
  }
}

#Preview {
  NavigationStack {
    ProfileMenuView(showProfileMenuSheet: .constant(false), activeSheet: ActiveSheet())
  }
}

extension ProfileMenuView {
  private var myInformation: some View {
    HStack(spacing: 15) {
      Image(UserSexType(type: (vm.currentUser?.sex ?? true)).getAvatar())
        .resizable()
        .scaledToFit()
        .clipShape(Circle())
        .frame(width: 60)
      
      VStack(alignment: .leading, spacing: 0) {
        Text(vm.currentUser?.name ?? "로그인해주세요")
          .customFont(.headlineB)
          .foregroundStyle(.black)
        
        if let fianceName = vm.fianceUser?.name {
          Text("\(fianceName)님의 \((vm.currentUser?.sex ?? true) ? UserSexType.man.rawValue : UserSexType.woman.rawValue)")
            .customFont(.caption1B)
            .foregroundStyle(.gray500)
        } else {
          Button {
            showProfileMenuSheet = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              activeSheet.kind = .signIn
            }
          } label: {
            Text("눌러서 로그인하기 >")
              .customFont(.caption1B)
              .foregroundStyle(.gray500)
          }
        }
      }
    }
  }
  
  private var marriageDday: some View {
    HStack {
      Label(
        title: {
          Text(vm.marriageStatus?.dDayMessage ?? "지금 로그인하고 결혼예정일을 설정해보세요.")
            .customFont(.caption1R)
            .foregroundStyle(.gray600)
        },
        icon: {
          Image("heart_calendar")
            .resizable()
            .scaledToFit()
            .frame(width: 16)
            .foregroundStyle(.gray600)
        }
      )
      .padding(.horizontal, 12)
      .padding(.vertical, 9)
      
      Spacer()
    }
    .background(Color.gray100)
    .cornerRadius(8, corners: .allCorners)
  }
  
  private var manageMyAccount: some View {
    VStack(alignment: .leading, spacing: 20) {
      Text("내 계정 관리")
        .foregroundStyle(.black)
        .customFont(.headlineB)
      
      Button {
        vm.showActionSheet = true
      } label: {
        listRowLabel(title: "내 정보 수정하기")
      }
      
      NavigationLink {
        ConnectionView()
      } label: {
        listRowLabel(title: "상대방과 연결 관리", isIssue: (vm.currentUser?.fiance) == nil)
      }
    }
    .padding(.horizontal, 20)
  }
  
  private var serviceUse: some View {
    VStack(alignment: .leading, spacing: 20) {
      Text("서비스 이용안내")
        .foregroundStyle(.black)
        .customFont(.headlineB)
      
      NavigationLink {
        EmbedWebView(viewTitle: "문답 연구소", urlString: ServiceWebURL.questionLab.rawValue, type: .navigation, showSheet: .constant(true), checkContract: .constant(true))
      } label: {
        listRowLabel(title: "문답 연구소")
      }
      
      NavigationLink {
        EmbedWebView(viewTitle: "고객센터", urlString: ServiceWebURL.qna.rawValue, type: .navigation, showSheet: .constant(true), checkContract: .constant(true))
      } label: {
        listRowLabel(title: "고객센터")
      }
      
      NavigationLink {
        EmbedWebView(viewTitle: "서비스 이용약관", urlString: ServiceWebURL.termsOfuse.rawValue, type: .navigation, showSheet: .constant(true), checkContract: .constant(true))
      } label: {
        listRowLabel(title: "서비스 이용약관")
      }
      
      NavigationLink {
        EmbedWebView(viewTitle: "개인정보 처리 방침", urlString: ServiceWebURL.privacyPolicy.rawValue, type: .navigation, showSheet: .constant(true), checkContract: .constant(true))
      } label: {
        listRowLabel(title: "개인정보 처리 방침")
      }
      
      HStack {
        Text("서비스 버전 정보")
          .customFont(.calloutR)
          .foregroundStyle(.gray800)
        
        Spacer()
        
        Text("2.0.0")
          .customFont(.footnoteB)
          .foregroundStyle(.gray400)
      }
    }
    .padding(.horizontal, 20)
  }
  
  private var exitAction: some View {
    VStack(alignment: .leading, spacing: 20) {
      Button {
        vm.showSignOutAlert = true
      } label: {
        listRowLabel(title: "로그아웃")
      }
      
      NavigationLink {
        WithdrawalMembershipView(showProfileMenuSheet: $showProfileMenuSheet)
      } label: {
        listRowLabel(title: "회원탈퇴")
      }
    }
    .padding(.horizontal, 20)
    
    .alert("로그아웃할까요?", isPresented: $vm.showSignOutAlert, actions: {
      Button("취소", role: .cancel) {
        vm.showSignOutAlert = false
      }
      
      Button("로그아웃", role: .destructive) {
        try? vm.signOut()
      }
    }, message: {
      Text("로그아웃하더라도 데이터는 보관되니\n안심하고 로그아웃하셔도 돼요.")
    })
  }
  
  private var menuSeparator: some View {
    Rectangle()
      .ignoresSafeArea()
      .frame(height: 12)
      .frame(maxWidth: .infinity)
      .foregroundStyle(.gray50)
  }
  
  private func listRowLabel(title: String, isIssue: Bool = false) -> some View {
    HStack {
      ZStack(alignment: .topTrailing) {
        Text(title)
          .customFont(.calloutR)
          .foregroundStyle(.gray800)
        
        if isIssue {
          Circle()
            .frame(width: 5)
            .foregroundStyle(.red)
            .offset(x: 8)
        }
      }
      
      Spacer()
      
      Image("angle-right-gray")
        .resizable()
        .scaledToFit()
        .frame(width: 10)
    }
  }
}
