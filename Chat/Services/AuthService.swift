//
//  AuthService.swift
//  Chat
//
//  Created by Антон on 04.04.2022.
//

import UIKit
import Firebase
import GoogleSignIn


class AuthService {
	
	//MARK: - Properties
	static let shared = AuthService() 
	private let auth = Auth.auth()
	
	//MARK: - Methods
	//MARK: - Sing in with Email
	func login(email: String?, password: String?, completion: @escaping (Result<User,Error>)->Void) {
		guard let email = email, let password = password else {
			completion(.failure(AuthError.notFilled))
			return
		}
		auth.signIn(withEmail: email, password: password) { (result, error) in
			guard let result = result else {
				completion(.failure(error!))
				return
			}
			completion(.success(result.user))
		}
	}
	
	//MARK: - Registation form with Email
	func register(email: String?, password: String?, confirmPassword: String?, completion: @escaping (Result<User,Error>)->Void){
		guard Validators.isFilled(email: email, password: password, confirmPassword: confirmPassword) else {
			completion(.failure(AuthError.notFilled))
			return
		}
		guard password!.lowercased() == confirmPassword!.lowercased() else {
			completion(.failure(AuthError.passwordNotMatched))
			return
		}
		guard Validators.isSimpleEmail(email!) else {
			completion(.failure(AuthError.invalidEmail))
			return
		}
		auth.createUser(withEmail: email!, password: password!) { result, error in
			guard let result = result else {
				completion(.failure(error!))
				return
			}
			completion(.success(result.user))
		}
	}
	
	//MARK: - Sing in with Google
	func googleLogin(user: GIDGoogleUser!, error: Error!, completion: @escaping (Result<User,Error>) -> Void) {
		if let error = error {
			completion(.failure(error))
			return
		}
		guard let auth = user?.authentication,
					let idToken = auth.idToken else { return }
		let credential = GoogleAuthProvider.credential(withIDToken: idToken,
																									 accessToken: auth.accessToken)
		Auth.auth().signIn(with: credential) { (result, error) in
			guard let result = result else {
				completion(.failure(error!))
				return
			}
			completion(.success(result.user))
		}
	}
	
	func googleSign(){
		guard let clientID = FirebaseApp.app()?.options.clientID else { return }
		let config = GIDConfiguration(clientID: clientID)
		GIDSignIn.sharedInstance.signIn(with: config, presenting: (UIApplication.getTopViewController())!) { user, error in
			AuthService.shared.googleLogin(user: user, error: error) { result in
				switch result {
				case .success(let user):
					FirestoreService.shared.getUserData(user: user) { result in
						switch result {
						case .success(let muser):
							UIApplication.getTopViewController()?.showAlert(title: "Успешно", message: "Вы авторизованы") {
								let mainTabBar = MainTabBarController(currentUser: muser)
								mainTabBar.modalPresentationStyle = .fullScreen
								UIApplication.getTopViewController()?.present(mainTabBar, animated: true, completion: nil)
							}
						case .failure(_):
							UIApplication.getTopViewController()?.showAlert(title: "Успешно", message: "Вы зарегистрированны") {
								UIApplication.getTopViewController()?.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
							}
						} // result
					}
				case .failure(let error):
					UIApplication.getTopViewController()?.showAlert(title: "Ошибка", message: error.localizedDescription)
				}
			}
		}
	}
}
