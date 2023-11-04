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
  private let hPadding = 20.0

  var body: some View {
    VStack(spacing: 0) {
      Spacer().frame(height: 4)
      
      if homeVM.isReady {
        ScrollView(showsIndicators: false) {
          Spacer().frame(height: 16)
          
          titleArea
            .padding(.horizontal, hPadding)
          
          Spacer().frame(height: 32)
          
          if homeVM.savedImage == nil {
            defaultImage
          } else {
            savedImage
          }
          
          Spacer().frame(height: 40)
          
          recommendArea
            .padding(.horizontal, hPadding)
          
          Spacer().frame(minHeight: 60)
        }
        
      } else {
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .background(backgroundDefault())
    
    .task {
      let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
      homeVM.showLoginView = authUser == nil

      if homeVM.showLoginView == false {
        try? await homeVM.setInfo()
      }
    }

    .fullScreenCover(isPresented: $homeVM.showLoginView) {
      NavigationStack {
        LoginView(showLoginView: $homeVM.showLoginView)
      }
      .onDisappear {
        Task { try? await homeVM.setInfo() }
      }
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
  
  private var recommendArea: some View {
    NavigationLink {
      if homeVM.recommendQuestionAnswered {
        AnswerCheckView(answerCheckVM: .init(questionId: homeVM.recommendQuestion.questionID), sex: !homeVM.fianceSexType.getBool)
      } else {
        AnswerWriteView(question: homeVM.recommendQuestion, isFromMain: true)
      }
    } label: {
      HomeRecommendView(recommendQuestion: homeVM.recommendQuestion.content)
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
      .frame(width: UIScreen.main.bounds.width - CGFloat(2 * hPadding))
      .frame(minHeight: 350, maxHeight: 380)
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
      .scaledToFill()
      .frame(width: UIScreen.main.bounds.width - CGFloat(2 * hPadding), height: 380)
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
