//
//  ViewController.swift
//  Chat
//
//  Created by Антон on 28.03.2022.
//

import UIKit
import Firebase
import GoogleSignIn

class AuthViewController: UIViewController {
	
	let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Logo"), contentMode: .scaleAspectFit)
	
	let googleLabel = UILabel(text: "Get started with")
	let emailLabel = UILabel(text: "Or sign up with")
	let aladyOnboardLabel = UILabel(text: "Already onboard?")
	

	let emailButton = UIButton(backrounColor: .buttonDark(), titleColor: .white, title: "Email")
	let loginButton = UIButton(backrounColor: .white, titleColor: .buttonRed(), title: "Login", isShadow: true)
	let googleButton = UIButton(backrounColor: .white, titleColor: .black, title: "Google", isShadow: true)
	let signUpVC = SignUpViewController()
	let loginVC = LoginViewController()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		setupConstraints()
		googleButton.customizeGoogleButton()
		emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
		loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
		googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
		signUpVC.delegate = self
		loginVC.delegate = self
	}
	
	@objc private func emailButtonTapped() {
		present(signUpVC, animated: true, completion: nil)
	}
	
	@objc private func loginButtonTapped() {
		present(loginVC, animated: true, completion: nil)
	}
	
	@objc private func googleButtonTapped() {
		guard let clientID = FirebaseApp.app()?.options.clientID else { return }
		let config = GIDConfiguration(clientID: clientID)
		GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
			
			guard let authentication = user?.authentication,
						let idToken = authentication.idToken else { return }
			
			let credential = GoogleAuthProvider.credential(withIDToken: idToken,
																										 accessToken: authentication.accessToken)
			AuthService.shared.googleLogin(user: user, error: error) { (result) in
				switch result {
				case .success(let user):
					FirestoreService.shared.getUserData(user: user) { (result) in
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
					self.showAlert(title: "Ошибка", message: error.localizedDescription)
				}
			}
		}
	}
}
			
			
			










//MARK: - Setup constraints

extension AuthViewController {
	private func setupConstraints() {
		logoImageView.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(logoImageView)
		let googleView = ButtonFormView(label: googleLabel, button: googleButton)
		let emailView = ButtonFormView(label: emailLabel, button: emailButton)
		let loginView = ButtonFormView(label: aladyOnboardLabel, button: loginButton)
		
		let stackView = UIStackView(arrangedSubviews: [googleView, emailView, loginView], axis: .vertical, spacing: 40)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		
		self.view.addSubview(logoImageView)
		self.view.addSubview(stackView)
		
		NSLayoutConstraint.activate([
		logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant:  160),
		logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
		])
			
		NSLayoutConstraint.activate([
		stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 160),
		stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
		stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40)
		])
	}
}


extension AuthViewController: AuthNavigationDelegateProtocol {
	func toLoginVC() {
		present(loginVC, animated: true, completion: nil)
	}
	
	func toSingUpVC() {
		present(signUpVC, animated: true, completion: nil)
	}
}





//MARK: - SWIFT UI
import SwiftUI

struct AuthVCProvider: PreviewProvider {
	static var previews: some View {
		Group {
			ContainerView().edgesIgnoringSafeArea(.all)
		}
	}
	
	struct ContainerView: UIViewControllerRepresentable {
		let viewController = AuthViewController()
		func makeUIViewController(context: UIViewControllerRepresentableContext<AuthVCProvider.ContainerView>) -> AuthViewController {
			return viewController
		}
		func updateUIViewController(_ uiViewController: AuthViewController, context: Context) {
			
		}
	}
}
