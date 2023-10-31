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
  @Published var fianceName: String = "UserName"
  @Published var fianceSexType: UserType = .woman
  @Published var untilWeddingDate: Int = 0
  @Published var qnaCount: Int = 0
  @Published var isConnected: Bool = false
  @Published var isConnectButtonTapped = false
  
  @Published var showDialog = false
  @Published var showPhotosPicker = false
  @Published var isReady = false
  
  @Published var recommendQuestion: DBStaticQuestion = .init(questionID: 0, category: "", content: "추천질문입니다")
  @Published var recommendQuestionAnswered: Bool = false
  
  // MARK: 메인 이미지 관련
  let manager = ImageFileManager.shared

  private let defaultImageName = "HomeDefaultImage"
  private let saveImageName = "save_main_image"
  
  @Published var selectedItem: PhotosPickerItem? = nil
  @Published var selectedImageData: Data? = nil
  @Published var savedImage: UIImage? = nil
  
  @AppStorage("savedRecommendQuestionId") var savedRecommendQuestionId: Int = 0
  @AppStorage("lastQuestionChangeDate") var lastQuestionChangeDate: Date = Date(timeIntervalSince1970: Date().timeIntervalSince1970 + 9 * 3600)
  
  var formattedCurrnetDate: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    return formatter.string(from: lastQuestionChangeDate)
  }
  
  private func chcekDateDiff(currentDate: Date, lastChangedDate: Date) -> Bool {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    var current = formatter.string(from: currentDate)
    var last = formatter.string(from: lastChangedDate)
    return current == last ? true : false
  }
  
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
    
    if self.isConnected == true {
      try await getFiance(user: dbUser)
      try getFianceSex(user: dbUser)
      try await getQnACount(user: dbUser)
    }
    
    try getMarrigeDate(user: dbUser)
    self.isReady = true
        
    // TODO: 라딘~ 이 함수에 문제가 있는지, 이 함수 이후에 정의한 함수에 접근하지 않습니다. 그래서 일단 맨 뒤로 옮겼어요.
    try await loadRecommendQuestion(user: dbUser)
    
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
    
    let bothanswered = try await UserManager.shared.getAnswerWithId(userId: fiance, filter: myAnswerIds)
    
    self.qnaCount = bothanswered.count
  }
  
  private func loadRecommendQuestion(user: DBUser) async throws {
    self.recommendQuestion = try await getQuestionsRecommend(userId: user.userId, fianceId: user.fiance)
    self.recommendQuestionAnswered = try await checkRecommendAnswered(user: user, questionId: recommendQuestion.questionID)

  }
  
  private func getQuestionsRecommend(userId: String, fianceId: String?) async throws -> DBStaticQuestion {
    
    // let currentDate = Calendar.current.startOfDay(for: Date())
    let currentDate = Date(timeIntervalSince1970: Date().timeIntervalSince1970 + 9 * 3600)
   
    print(currentDate)
    print(lastQuestionChangeDate)
    
    chcekDateDiff(currentDate: currentDate, lastChangedDate: lastQuestionChangeDate)
    
    if lastQuestionChangeDate == nil || !chcekDateDiff(currentDate: currentDate, lastChangedDate: lastQuestionChangeDate) { //currentDate != Calendar.current.startOfDay(for: lastQuestionChangeDate) {
      lastQuestionChangeDate = currentDate
      
      
      let answers = try await StaticQuestionManager.shared.getQuestionsWithoutAnswers(myId: userId, fianceId: fianceId)
//      if answers.isEmpty { throw URLError(.badURL) }
      
      ///EssentialQuestion 우선 불러오기
      for answer in answers {
        if StaticQuestionManager.shared.essentialQuestionsId.contains(answer.questionID) {
          return answer
        }
      }
      let randomQuestion = answers.randomElement()!
      savedRecommendQuestionId = randomQuestion.questionID
      
      return randomQuestion
    } else {
      return try await StaticQuestionManager.shared.getQuestionById(id: savedRecommendQuestionId)
    }
  }
  
  func checkRecommendAnswered(user: DBUser, questionId: Int) async throws -> Bool {
    let answer = try await UserManager.shared.getAnswer(userId: user.userId, questionId: questionId)
    if answer == nil {
      return false
    }
    return true
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
