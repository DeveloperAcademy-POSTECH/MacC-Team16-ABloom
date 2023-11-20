//
//  ProfileMenuView.swift
//  ABloom
//
//  Created by 정승균 on 11/15/23.
//

import SwiftUI

struct ProfileMenuView: View {
  
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
      }
      
    }
    .padding(.top, 27)
    
    .customNavigationBar {
      EmptyView()
    } leftView: {
      Button("취소") {
        
      }
      .customFont(.calloutB)
      .foregroundStyle(.purple700)
    } rightView: {
      EmptyView()
    }
    .padding(.top, 16)
    
    .ignoresSafeArea(.all, edges: .bottom)

  }
}

#Preview {
  NavigationStack {
    ProfileMenuView()
  }
}

extension ProfileMenuView {
  private var myInformation: some View {
    HStack(spacing: 15) {
      Circle()
        .fill(Color.gray)
        .frame(width: 60)
      
      VStack(alignment: .leading, spacing: 0) {
        Text(vm.currentUser?.name ?? "로그인해주세요")
          .customFont(.headlineB)
          .foregroundStyle(.black)
        
        if let fianceName = vm.fianceUser?.name {
          Text("\(vm.fianceUser?.name ?? "눌러서 로그인하기 >")님의 \((vm.currentUser?.sex ?? true) ? UserSexType.man.rawValue : UserSexType.woman.rawValue)")
            .customFont(.caption1B)
            .foregroundStyle(.gray500)
        } else {
          Text("눌러서 로그인하기 >")
            .customFont(.caption1B)
            .foregroundStyle(.gray500)
        }
      }
    }
  }
  
  private var marriageDday: some View {
    ZStack {
      HStack {
        Label(
          title: {
            Text(vm.marriageStatus?.dDayMessage ?? "로그인 해주세요")
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
    }
    .frame(maxWidth: .infinity)
    .background(Color.gray100)
    .cornerRadius(8, corners: .allCorners)
  }
  
  private var manageMyAccount: some View {
    VStack(alignment: .leading, spacing: 20) {
      Text("내 계정 관리")
        .foregroundStyle(.black)
        .customFont(.headlineB)
      
      Button {
        // 내 정보 수정 액션 시트
      } label: {
        listRowLabel(title: "내 정보 수정하기")
      }
      
      Button {
        // 연결 관리 뷰 연동
      } label: {
        listRowLabel(title: "상대방과 연결 관리")
      }
    }
    .padding(.horizontal, 20)
  }
  
  private var serviceUse: some View {
    VStack(alignment: .leading, spacing: 20) {
      Text("서비스 이용안내")
        .foregroundStyle(.black)
        .customFont(.headlineB)
      
      Button {
        // 문답 연구소 웹뷰 연동
      } label: {
        listRowLabel(title: "문답 연구소")
      }
      
      Button {
        // 고객센터 웹뷰 연동
      } label: {
        listRowLabel(title: "고객센터")
      }
      
      Button {
        // 서비스 이용약관 수정 웹뷰 연동
      } label: {
        listRowLabel(title: "서비스 이용약관")
      }
      
      Button {
        // 개인정보 처리방침 웹뷰 연동
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
        try? vm.signOut()
      } label: {
        listRowLabel(title: "로그아웃")
      }
      
      Button {
        // 회원탈퇴 뷰 연동
      } label: {
        listRowLabel(title: "회원탈퇴")
      }
    }
    .padding(.horizontal, 20)
  }
  
  private var menuSeparator: some View {
    Rectangle()
      .ignoresSafeArea()
      .frame(height: 12)
      .frame(maxWidth: .infinity)
      .foregroundStyle(.gray50)
  }
  
  private func listRowLabel(title: String) -> some View {
    HStack {
      Text(title)
        .customFont(.calloutR)
        .foregroundStyle(.gray800)
      
      Spacer()
      
      Image("angle-right-gray")
        .resizable()
        .scaledToFit()
        .frame(width: 10)
    }
  }
}
