//
//  SignUpViewController.swift
//  Chat
//
//  Created by Антон on 29.03.2022.
//

import UIKit

class SignUpViewController: UIViewController {
	
	
	//MARK: - Properties
	//labels
	let welcomeLabel = UILabel(text: "Good to see you!", font: .avenir26())
	let emailLabel = UILabel(text: "Email")
	let passwordLabel = UILabel(text: "Password")
	let confirmPasswordLabel = UILabel(text: "Confirm password")
	let alreadyOnboardLabel = UILabel(text: "Already onboard?")
	
	//textFileds
	let emailTextField = OneLineTextField(font: .avenir20())
	let passwordTextField = OneLineTextField(font: .avenir20())
	let confirmPasswordTextField = OneLineTextField(font: .avenir20())
	
	//buttons
	let signUpButton = UIButton(backrounColor: .buttonDark(), titleColor: .white, title: "Sign Up", cornerRaadius: 4)
	let loginButton: UIButton = {
		let loginButton = UIButton(type: .system)
		loginButton.setTitle("Login", for: .normal)
		loginButton.setTitleColor(.buttonRed(), for: .normal)
		loginButton.titleLabel?.font = .avenir20()
		loginButton.contentHorizontalAlignment = .left
		loginButton.contentVerticalAlignment = .bottom
		return loginButton
	}()
	
	weak var delegate: AuthNavigationDelegateProtocol?
	
	
	//MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConstraints()
		buttonTargetsAndDelegate()
	}
	
	
	//MARK: - Methods
	private func buttonTargetsAndDelegate(){
		signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
		loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
		self.emailTextField.delegate = self
		self.passwordTextField.delegate = self
		self.confirmPasswordTextField.delegate = self
	}
	
	@objc private func signUpButtonTapped() {
		AuthService.shared.register(email: emailTextField.text,
																password: passwordTextField.text,
																confirmPassword: confirmPasswordTextField.text) { (result) in
			switch result {
			case .success(let user):
				self.showAlert(title: "Success!", message: "You are registered") {
					self.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
				}
			case .failure(let error):
				self.showAlert(title: "Error", message: "\(error.localizedDescription)")
			}
		}
	}
	
	@objc private func loginButtonTapped() {
		self.dismiss(animated: true) {
			self.delegate?.toLoginVC()
		}
	}
}


//MARK: - extensions
extension SignUpViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
}


//MARK: - Setup constraints
extension SignUpViewController {
	private func setupConstraints() {
		let emailStackView = UIStackView(arrangedSubviews: [emailLabel,
																												emailTextField], axis: .vertical, spacing: 0)
		let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel,
																													 passwordTextField], axis: .vertical, spacing: 0)
		let confirmPasswordStackView = UIStackView(arrangedSubviews: [confirmPasswordLabel,
																																	confirmPasswordTextField], axis: .vertical, spacing: 0)
		
		let stackView = UIStackView(arrangedSubviews: [emailStackView,
																									 passwordStackView,
																									 confirmPasswordStackView,
																									 signUpButton], axis: .vertical, spacing: 30)
		
    let bottomStackView = UIStackView(arrangedSubviews: [alreadyOnboardLabel, loginButton], axis: .horizontal, spacing: 20)
		bottomStackView.alignment = .firstBaseline
		self.view.backgroundColor = .white
		
		stackView.translatesAutoresizingMaskIntoConstraints = false
		bottomStackView.translatesAutoresizingMaskIntoConstraints = false
		welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(welcomeLabel)
		view.addSubview(stackView)
		view.addSubview(bottomStackView)
		
		signUpButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
		NSLayoutConstraint.activate ([
			welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
			welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			welcomeLabel.heightAnchor.constraint(equalToConstant: 35)
		])
	
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 120),
			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
			stackView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -60)
		])
		
		NSLayoutConstraint.activate([
			bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 60),
			bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
			bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
			bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
		])
	}
}


//MARK: - SWIFT UI
import SwiftUI

struct SignUpVCProider: PreviewProvider {
	static var previews: some View {
		Group {
			ContainerView().edgesIgnoringSafeArea(.all)
		}
	}
	
	struct ContainerView: UIViewControllerRepresentable {
		let signUpVC = SignUpViewController()
		func makeUIViewController(context: UIViewControllerRepresentableContext<SignUpVCProider.ContainerView>) -> SignUpViewController {
			return signUpVC
		}
		func updateUIViewController(_ uiViewController: SignUpViewController, context: Context) {
			
		}
	}
}


