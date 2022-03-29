//
//  LoginViewController.swift
//  Chat
//
//  Created by Антон on 29.03.2022.
//

import UIKit

class LoginViewController: UIViewController {
	
	
	let googleLabel = UILabel(text: "Login with")
	let orLabel = UILabel(text: "or")
	let newAccountLabel = UILabel(text: "Need an account?")
	let emailLabel = UILabel(text: "Email")
	let PasswordLabel = UILabel(text: "Password?")

	let emailButton = UIButton(backrounColor: .buttonDark(), titleColor: .white, title: "Email")
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		   view.backgroundColor = .systemBlue
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
