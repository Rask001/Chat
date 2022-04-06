//
//  LoginViewController.swift
//  Chat
//
//  Created by Антон on 29.03.2022.
//

import UIKit


class LoginViewController: UIViewController {
	
	
	let welcomeLabel = UILabel(text: "Welcome Back!", font: .avenir26())
	
	let googleLabel = UILabel(text: "Login with")
	let orLabel = UILabel(text: "or")
	let newAccountLabel = UILabel(text: "Need an account?")
	let emailLabel = UILabel(text: "Email")
	let passwordLabel = UILabel(text: "Password")
	
	let emailTextField = OneLineTextField(font: .avenir20())
	let passwordTextField = OneLineTextField(font: .avenir20())
	
	let loginButton = UIButton(backrounColor: .buttonDark(), titleColor: .white, title: "Login", cornerRaadius: 4)
	let googleButton = UIButton(backrounColor: .white, titleColor: .black, title: "Google", isShadow: true)
	let signUpButton: UIButton = {
		let signUpButton = UIButton(type: .system)
		signUpButton.setTitle("Sign up", for: .normal)
		signUpButton.setTitleColor(.buttonRed(), for: .normal)
		signUpButton.titleLabel?.font = .avenir20()
		signUpButton.contentHorizontalAlignment = .left
		signUpButton.contentVerticalAlignment = .bottom
		return signUpButton
	}()
	
	weak var delegate: AuthNavigationDelegateProtocol?

	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConstraints()
		googleButton.customizeGoogleButton()
		   view.backgroundColor = .white
		loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
		signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
	}
	
	@objc private func loginButtonTapped() {
		AuthService.shared.login(email: emailTextField.text!,
														 password: passwordTextField.text!) { result in
			switch result {
				
			case .success(let user):
				self.showAllert(title: "Success!", message: "You are auturization") {
					FirestoreService.shared.getUserData(user: user) { result in
						switch result {
						case .success(let muser):
							self.present(MainTabBarController(), animated: true, completion: nil)
						case .failure(let error):
							self.showAllert(title: "", message: "заполните профиль"){
							self.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
							}
						}
					}
				}
			case .failure(let error):
				self.showAllert(title: "Error", message: "\(error.localizedDescription)")
			}
		}
		
	}
	@objc private func signUpButtonTapped() {
		self.dismiss(animated: true) {
			self.delegate?.toSingUpVC()
		}
}
}


extension LoginViewController {
	private func setupConstraints() {
		
		let	googleStackView = ButtonFormView(label: googleLabel, button: googleButton)
		let	emailStackView = UIStackView (arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
		let	passwordStackView = UIStackView (arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 0)
		loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
		
		let stackView = UIStackView (arrangedSubviews: [googleStackView,
																										orLabel,
																										emailStackView,
																										passwordStackView,
																										loginButton
																									 ], axis: .vertical, spacing: 30)

	  let bottomStackView = UIStackView (arrangedSubviews: [newAccountLabel,
																													signUpButton
																												 ], axis: .horizontal, spacing: 20)
		
		bottomStackView.alignment = .firstBaseline
		stackView.translatesAutoresizingMaskIntoConstraints = false
		bottomStackView.translatesAutoresizingMaskIntoConstraints = false
		welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
		
		
		view.addSubview(welcomeLabel)
		view.addSubview(stackView)
		view.addSubview(bottomStackView)
		
		
		NSLayoutConstraint.activate([
			welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
			welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			welcomeLabel.heightAnchor.constraint(equalToConstant: 35)
		])
		
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 60),
			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
			stackView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -60)
		])
		
		NSLayoutConstraint.activate([
			bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 60),
			bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
			bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
			bottomStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50)
		])
		
		
}
}






//MARK: - SWIFT UI
import SwiftUI

struct LoginVCProider: PreviewProvider {
	static var previews: some View {
		Group {
			ContainerView().edgesIgnoringSafeArea(.all)
		}
	}
	
	struct ContainerView: UIViewControllerRepresentable {
		let loginVC = LoginViewController()
		func makeUIViewController(context: UIViewControllerRepresentableContext<LoginVCProider.ContainerView>) -> LoginViewController {
			return loginVC
		}
		func updateUIViewController(_ uiViewController: LoginViewController, context: Context) {
			
		}
	}
}
