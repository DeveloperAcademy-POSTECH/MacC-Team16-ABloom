//
//  HomeView.swift
//  ABloom
//
//  Created by yun on 10/11/23.
//

import SwiftUI

struct HomeView: View {
  @StateObject var homeVM = HomeViewModel()
  
  var body: some View {
    ZStack {
      Image("BG").ignoresSafeArea()
      VStack {
        Spacer().frame(height: 73)
        HStack {
          VStack(alignment: .leading, spacing: 6) {
            Text(homeVM.isConnected ? "\(homeVM.partnerName)님과 결혼까지" : "\(homeVM.partnerType.rawValue)님과")
              .foregroundStyle(.stone800)
              .fontWithTracking(fontStyle: .title3Bold)
            
            Text(homeVM.isConnected ? "\(homeVM.untilWeddingDate)일, \(homeVM.qnaCount)개의 문답" : "연결해주세요")
              .foregroundStyle(.stone700)
              .fontWithTracking(fontStyle: .title1Bold)
          }
          .multilineTextAlignment(.leading)
          Spacer()
        }
        
        Spacer().frame(height: 32)
        
        Image(systemName: "")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .scaleEffect(0.2)
          .frame(height: 406)
          .overlay {
            RoundedRectangle(cornerRadius: 12)
              .mainImgShadow()
              .foregroundStyle(.biPink.opacity(0.2))
              .overlay(alignment: .topTrailing) {
                Button {
                  print("Btn Tapped")
                } label: {
                  Image(systemName: "camera.circle")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .foregroundStyle(.white)
                    .padding(.all, 16)
                }
              }
          }
        
        Spacer().frame(height: 40)

        HomeRecommendView(recommendQuestion: homeVM.recommendQuestion)
          
        Spacer()
      }
      .padding(.horizontal, 20)
    }
    .ignoresSafeArea()
  }
}

#Preview {
  HomeView()
}
