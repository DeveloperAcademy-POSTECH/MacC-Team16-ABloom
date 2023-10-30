//
//  HomeView.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/19/23.
//

import PhotosUI
import SwiftUI

struct HomeView: View {
  @StateObject var homeVM = HomeViewModel()
  
  var body: some View {
    VStack {
      Spacer().frame(maxHeight: 20)
      
      titleArea
      
      Spacer().frame(maxHeight: 32)
      
      if homeVM.savedImage == nil {
        defaultImage
      } else {
        savedImage
      }
      
      Spacer().frame(maxHeight: 40)
      
      NavigationLink(value: homeVM.recommendQuestion) {
        HomeRecommendView(recommendQuestion: homeVM.recommendQuestion.content)
      }
      
      Spacer()
    }
    .padding(.horizontal, 20)
    .background(backgroundDefault())
    .task {
      try? await homeVM.setInfo()
    }
    
    .navigationDestination(for: DBStaticQuestion.self) { question in
      AnswerWriteView(question: question)
    }
  }
}

#Preview {
  HomeView()
}

extension HomeView {
  
  private var titleArea: some View {
    HStack {
      VStack(alignment: .leading, spacing: 6) {
        Text(homeVM.isConnected ? "\(homeVM.fianceName)님과 결혼까지" : "\(homeVM.fianceSexType.rawValue)님과")
          .foregroundStyle(.stone800)
          .fontWithTracking(.headlineR)
        HStack(spacing: 12) {
          Text(homeVM.isConnected ? "\(homeVM.untilWeddingDate)일, \(homeVM.qnaCount)개의 문답" : "연결해주세요")
            .foregroundStyle(.stone700)
            .fontWithTracking(.title1Bold)
          
          if !homeVM.isConnected {
            connectButton
          }
        }
      }
      .multilineTextAlignment(.leading)
      
      Spacer()
    }
  }
  
  private var connectButton: some View {
    Button {
      homeVM.connectButtonTapped()
    } label: {
      Circle()
        .fill(
          .shadow(.inner(color: Color.black.opacity(0.3), radius: 4, x: 0, y: -2.5))
          .shadow(.inner(color: Color.white.opacity(0.5), radius: 6, x: 2.5, y: 0.8))
        )
        .frame(width: 24, height: 24)
        .foregroundStyle(purpleGradient65())
        .overlay {
          Image("link.white")
            .resizable()
            .scaledToFit()
            .frame(width: 11, height: 11)
        }
    }
    .navigationDestination(isPresented: $homeVM.isConnectButtonTapped) {
      MyAccountConnectingView()
    }
  }
  
  private var savedImage: some View {
    Image(uiImage: homeVM.savedImage!)
      .resizable()
      .scaledToFill()
      .frame(maxHeight: 387)
      .overlay {
        Color.biPink.opacity(0.2)
      }
      .clipShape(RoundedRectangle(cornerRadius: 28))
      .shadow(color: Color.purple200, radius: 20, x: 0, y: 20)
      .overlay(alignment: .topTrailing) {
        ZStack(alignment: .topTrailing) {
          cameraButton
        }
      }
  }
  
  private var defaultImage: some View {
    Image(uiImage: homeVM.defaultImage)
      .resizable()
      .scaledToFit()
      .frame(maxHeight: 387)
      .clipShape(RoundedRectangle(cornerRadius: 28))
      .shadow(color: Color.purple200, radius: 20, x: 0, y: 20)
      .overlay(alignment: .topTrailing) {
        ZStack(alignment: .topTrailing) {
          cameraButton
          cameraChatBubble
        }
      }
  }
  
  private var cameraButton: some View {
    Button {
      homeVM.cameraButtonTapped()
    } label: {
      Image("camera.filled.circle_outline")
        .resizable()
        .frame(width: 26, height: 26)
        .padding(.all, 14)
    }
    
    .confirmationDialog("사진", isPresented: $homeVM.showDialog) {
      Button("사진 추가하기", role: .none) {
        homeVM.addImageDialogTapped()
      }
      
      Button("사진 삭제하기", role: .destructive) {
        homeVM.deleteImage()
      }
      
      Button("취소", role: .cancel) {
        homeVM.showDialog = false
      }
    }
    
    .photosPicker(isPresented: $homeVM.showPhotosPicker, selection: $homeVM.selectedItem, matching: .all(of: [.images]), photoLibrary: .shared())
    
    .onChange(of: homeVM.selectedItem) { newItem in
      Task {
        if let data = try? await newItem?.loadTransferable(type: Data.self) {
          homeVM.selectedImageData = data
          homeVM.getImageFromPhotosPicker()
          homeVM.saveImage()
        }
      }
    }
  }
  
  private var cameraChatBubble: some View {
    Rectangle()
      .clayMorpMDShadow()
      .cornerRadius(14, corners: [.bottomLeft, .bottomRight, .topLeft])
      .frame(width: 155, height: 52)
      .foregroundStyle(.purple300)
      .overlay(alignment: .leading) {
        Text("우리의 추억을 담은\n커버 사진을 등록해주세요.")
          .foregroundStyle(.stone900)
          .font(.custom("SpoqaHanSansNeo-Regular", size: 12))
          .tracking(-0.4)
          .lineSpacing(2)
          .padding(.leading, 14)
      }
      .padding([.trailing, .top], 40)
  }
}
