//
//  HomeViewModel.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/19/23.
//

import PhotosUI
import SwiftUI

enum MarriageStatus: String {
  case notMarried = "님과 결혼까지"
  case married = "님과 결혼한지"
}

@MainActor
final class HomeViewModel: ObservableObject {
  @Published var fianceName: String = "UserName"
  @Published var fianceSexType: UserType = .woman
  @Published var untilWeddingDate: Int = 0
  @Published var marriageStatus: MarriageStatus = .notMarried
  @Published var qnaCount: Int = 0
  @Published var isConnected: Bool = false
  @Published var isConnectButtonTapped = false
  
  @Published var showLoginView = false
  
  @Published var showDialog = false
  @Published var showPhotosPicker = false
  @Published var isReady = false
  
  @Published var recommendQuestion: DBStaticQuestion = .init(questionID: 3, category: "", content: "추천질문입니다")
  @Published var recommendQuestionAnswered: Bool = false
  
  // MARK: 메인 이미지 관련
  let manager = ImageFileManager.shared

  private let defaultImageName = "HomeDefaultImage"
  private let saveImageName = "save_main_image"
  
  @Published var selectedItem: PhotosPickerItem? = nil
  @Published var selectedImageData: Data? = nil
  @Published var savedImage: UIImage? = nil
  
  @AppStorage("savedRecommendQuestionId") var savedRecommendQuestionId: Int = 3
  @AppStorage("lastQuestionChangeDate") var lastQuestionChangeDate: Date = Calendar.current.date(byAdding: .day, value: -2, to: Date())!

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
    
    self.isConnected = dbUser.fiance != nil
    try getFianceSex(user: dbUser)
    
    if self.isConnected == true {
      try await getFiance(user: dbUser)
      try await getQnACount(user: dbUser)
    }
    
    try getMarrigeDate(user: dbUser)
    try await loadRecommendQuestion(user: dbUser)
    
    self.isReady = true
  }
  
  private func getFianceSex(user: DBUser) throws {
    guard let userSex = user.sex else { throw URLError(.badServerResponse) }
    self.fianceSexType = userSex ? .woman : .man
  }
  
  private func getFiance(user: DBUser) async throws {
    guard let fiance = user.fiance else { throw URLError(.badServerResponse) }
    let fianceUser = try await UserManager.shared.getUser(userId: fiance)
    self.fianceName = fianceUser.name ?? ""
  }
  
  private func getMarrigeDate(user: DBUser) throws {
    guard let marrigeDate = user.marriageDate else { throw URLError(.badServerResponse) }
    self.untilWeddingDate = updateDDayStatus(marriageDate: marrigeDate)
  }
  
  private func updateDDayStatus(marriageDate: Date) -> Int {
    let dDay = Date().calculateDDay(with: marriageDate)
    
    if dDay <= 0 {
      marriageStatus = .married
      return -dDay + 1
    } else {
      marriageStatus = .notMarried
      return dDay
    }
  }
  
  private func getQnACount(user: DBUser) async throws {
    guard let fiance = user.fiance else { throw URLError(.badURL)}
    
    let myAnswers = try await UserManager.shared.getAnswers(userId: user.userId)
    let myAnswerIds = myAnswers.map { $0.questionId }
    
    let bothanswered = try await UserManager.shared.getAnswerWithId(userId: fiance, filter: myAnswerIds)
    
    self.qnaCount = bothanswered.count
  }
  
  private func loadRecommendQuestion(user: DBUser) async throws {
    let currentDate = Date.now
    
    if currentDate.isSameDate(lastChangedDate: lastQuestionChangeDate) {
      self.recommendQuestion = try await StaticQuestionManager.shared.getQuestionById(id: savedRecommendQuestionId)
    } else {
      self.recommendQuestion = try await getQuestionsRecommend(userId: user.userId, fianceId: user.fiance)
      lastQuestionChangeDate = currentDate
    }
    
    self.recommendQuestionAnswered = try await checkRecommendAnswered(user: user, questionId: recommendQuestion.questionID)
  }
  
  private func getQuestionsRecommend(userId: String, fianceId: String?) async throws -> DBStaticQuestion {
    
    try await StaticQuestionManager.shared.fetchEssentialCollections()
    let questions = try await StaticQuestionManager.shared.getQuestionsWithoutAnswers(myId: userId, fianceId: fianceId)
    
    let essentialOrderList = StaticQuestionManager.shared.essentialQuestionsOrder
    let essentialRandomList = StaticQuestionManager.shared.essentialQuestionsRandom
    
    for essentialquestion in essentialOrderList {
      for question in questions {
        if essentialquestion == question.questionID {
          savedRecommendQuestionId = question.questionID
          return question
        }
      }
    }
    
    for essentialQuestion in essentialRandomList {
      for question in questions {
        if essentialQuestion == question.questionID {
          savedRecommendQuestionId = question.questionID
          return question
        }
      }
    }
    
    let randomQuestion = questions.randomElement()!
    savedRecommendQuestionId = randomQuestion.questionID
    
    return randomQuestion
  }
  
  func checkRecommendAnswered(user: DBUser, questionId: Int) async throws -> Bool {
    do {
      let answer = try await UserManager.shared.getAnswer(userId: user.userId, questionId: questionId)
      return true
    } catch {
      return false
    }
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
