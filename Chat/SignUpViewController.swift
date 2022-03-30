//
//  SignUpViewController.swift
//  Chat
//
//  Created by Антон on 29.03.2022.
//

import UIKit

class SignUpViewController: UIViewController {
	
	let welcomeLabel = UILabel(text: "Good to see you!", font: .avenir26())
	
	let emailLabel = UILabel(text: "Email")
	let passwordLabel = UILabel(text: "Eassword")
	let confirmPasswordLabel = UILabel(text: "Confirm password")
	let alreadyOnboardLabel = UILabel(text: "Already onboard?")
	let emailTextField = OneLineTextField(font: .avenir20())
	let passwordTextField = OneLineTextField(font: .avenir20())
	let confirmPasswordTextField = OneLineTextField(font: .avenir20())
	
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
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		setupConstraints()
	}
}

//MARK: - Setup constraints

extension SignUpViewController {
	private func setupConstraints() {
		let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
		let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 0)
		let confirmPasswordStackView = UIStackView(arrangedSubviews: [confirmPasswordLabel, confirmPasswordTextField], axis: .vertical, spacing: 0)
		
		signUpButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
		
		let stackView = UIStackView(arrangedSubviews: [emailStackView,
																									 passwordStackView,
																									 confirmPasswordStackView,
																									 signUpButton], axis: .vertical, spacing: 40)
		
    let bottomStackView = UIStackView(arrangedSubviews: [alreadyOnboardLabel, loginButton], axis: .horizontal, spacing: 20)
		bottomStackView.alignment = .firstBaseline
		stackView.translatesAutoresizingMaskIntoConstraints = false
		bottomStackView.translatesAutoresizingMaskIntoConstraints = false
		welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(welcomeLabel)
		view.addSubview(stackView)
		view.addSubview(bottomStackView)
		
		NSLayoutConstraint.activate ([
			welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
			welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
	
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 160),
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