//
//  HomeViewModel.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/19/23.
//

import PhotosUI
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
  @Published var partnerName: String = "UserName"
  @Published var untilWeddingDate: Int = 0
  @Published var qnaCount: Int = 0
  @Published var isConnected: Bool = false
  @Published var partnerType: UserType = .woman
  @Published var recommendQuestion: String = "추천질문입니다"
  @Published var isConnectButtonTapped = false
  
  @Published var showDialog = false
  @Published var showPhotosPicker = false
  
  // MARK: 메인 이미지 관련
  let manager = ImageFileManager.shared

  private let defaultImageName = "HomeDefaultImage"
  private let saveImageName = "save_main_image"
  
  @Published var selectedItem: PhotosPickerItem? = nil
  @Published var selectedImageData: Data? = nil
  @Published var savedImage: UIImage? = nil
  
  var defaultImage: UIImage {
    UIImage(named: defaultImageName)!
  }
  
  private var status: PHAuthorizationStatus {
    PHPhotoLibrary.authorizationStatus(for: .readWrite)
  }
  
  init() {
    getImageFromFileManager()
  }
  
  func cameraButtonTapped() {
    showDialog = true
  }
  
  func addImageDialogTapped() {
    requestAuthorization()
    showPhotosPicker = true
  }
  
  func connectButtonTapped() {
    isConnectButtonTapped = true
  }
  
  func setInfo() async throws {
    let dbUser = try await UserManager.shared.getCurrentUser()
    try await getFiance(user: dbUser)
    try getMarrigeDate(user: dbUser)
    try await getQnACount(user: dbUser)
    self.isConnected = true
  }
  
  private func getFiance(user: DBUser) async throws {
    guard let fiance = user.fiance else { throw URLError(.badServerResponse) }
    
    let fianceUser = try await UserManager.shared.getUser(userId: fiance)
    
    self.partnerName = fianceUser.name ?? ""
  }
  
  private func getMarrigeDate(user: DBUser) throws {
    guard let marrigeDate = user.marriageDate else { throw URLError(.badServerResponse) }
    self.untilWeddingDate = calculateDDay(estimatedMarriageDate: marrigeDate)
  }
  
  private func calculateDDay(estimatedMarriageDate: Date) -> Int {
    let today = Date()
    
    guard let days = Calendar.current.dateComponents([.day], from: today, to: estimatedMarriageDate).day else { return 0 }
    
    return days + 1
  }
  
  private func getQnACount(user: DBUser) async throws {
    guard let fiance = user.fiance else { throw URLError(.badURL)}
    
    let myAnswers = try await UserManager.shared.getAnswers(userId: user.userId)
    let myAnswerIds = myAnswers.map { $0.questionId }
    
    let bothAnswerd = try await UserManager.shared.getAnswerWithId(userId: fiance, filter: myAnswerIds)
    
    self.qnaCount = bothAnswerd.count
  }
  
  // MARK: - 메인 이미지 관련
  private func requestAuthorization() {
    guard status == .notDetermined else { return }
    PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
      // TODO: 요청권한에 따른 처리
    }
  }
  
  // 파일에서 이미지 가져오기
  private func getImageFromFileManager() {
    if let image = manager.loadImage(name: saveImageName) {
      self.savedImage = image
    }
  }
  
  func getImageFromPhotosPicker() {
    if let image = UIImage(data: selectedImageData!) {
      self.savedImage = image
    }
  }
  
  func saveImage() {
    guard let image = savedImage else { return }
    manager.saveImage(image: image, name: saveImageName)
  }
  
  func deleteImage() {
    selectedItem = nil
    selectedImageData = nil
    savedImage = nil
    manager.deleteImage(name: saveImageName)
  }
}
