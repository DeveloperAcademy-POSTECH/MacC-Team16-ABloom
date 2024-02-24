//
//  SignInGoogleHelper.swift
//  ABloom
//
//  Created by Lee Jinhee on 1/13/24.
//

import FirebaseAuth
import FirebaseCore
import GoogleSignIn

final class SignInGoogleHelper {
  @MainActor
  func startWithGoogle() async throws -> AuthCredential? {
    guard let clientID = FirebaseApp.app()?.options.clientID else { return nil }
    
    GIDSignIn.sharedInstance.configuration =  GIDConfiguration(clientID: clientID)
    
    guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return nil }

    let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)
    
    guard let idToken = gidSignInResult.user.idToken?.tokenString else {
      throw URLError(.badServerResponse)
    }
    let accessToken = gidSignInResult.user.accessToken.tokenString
    
    let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
    return credential
  }
  
  func signOut() {
    GIDSignIn.sharedInstance.signOut()
  }
  
  func deleteAccount() {
    GIDSignIn.sharedInstance.disconnect()
  }
}
