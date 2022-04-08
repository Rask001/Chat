//
//  SetupProfileViewController.swift
//  Chat
//
//  Created by Антон on 31.03.2022.
//

import UIKit
import Firebase

class SetupProfileViewController: UIViewController {
	
	let fillImageView = AddPhotoView()
	let welcomeLabel = UILabel(text: "Setup profile", font: .avenir26())
	
	let fullNameLabel = UILabel(text: "Full name")
	let aboutMeLabel = UILabel(text: "About me")
	let sexLabel = UILabel(text: "sex")
	
	let fullNameTF = OneLineTextField(font: .avenir20())
	let aboutMeTF = OneLineTextField(font: .avenir20())
	let sexSegmentedControl = UISegmentedControl(first: "Male", second: "Female")
	let goToChatsButton = UIButton(backrounColor: .buttonDark(), titleColor: .white, title: "Go to chats!")
	
	private let currentUser: User
	init(currentUser: User) {
		self.currentUser = currentUser
		super.init(nibName: nil, bundle: nil)
		if let username = currentUser.displayName {
			fullNameTF.text = username
		}
		//потом сделать аватарку
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConstraints()
		goToChatsButton.addTarget(self, action: #selector(goToChatsButtonTapped), for: .touchUpInside)
	}
	
	@objc private func goToChatsButtonTapped() {
		FirestoreService.shared.saveProfileWith(id: currentUser.uid,
																						email: currentUser.email!,
																						username: fullNameTF.text,
																						avatagImageString: nil,
																						description: aboutMeTF.text,
																						sex: sexSegmentedControl.titleForSegment(at: sexSegmentedControl.selectedSegmentIndex)) { result in
			switch result {
				
			case .success(let muser):
				self.showAlert(title: "данные сохранены!", message: "Приятного общения!") {
					let mainTabBar = MainTabBarController(currentUser: muser)
					mainTabBar.modalPresentationStyle = .fullScreen
					self.present(mainTabBar, animated: true, completion: nil)
				}
				
			case .failure(let error):
				self.showAlert(title: "error", message: error.localizedDescription)
			}
		}
	}
	
}


//MARK: - Setup constraints
extension SetupProfileViewController {
	private func setupConstraints() {
		self.view.backgroundColor = .white
		
		let fullImageStackView = UIStackView(arrangedSubviews: [fullNameLabel, fullNameTF], axis: .vertical, spacing: 0)
		let aboutMeStackView = UIStackView(arrangedSubviews: [aboutMeLabel, aboutMeTF], axis: .vertical, spacing: 0)
		let sexStackView = UIStackView(arrangedSubviews: [sexLabel, sexSegmentedControl], axis: .vertical, spacing: 12)
		
		
		let stackView = UIStackView(arrangedSubviews: [fullImageStackView,
																									 aboutMeStackView,
																									 sexStackView,
																									 goToChatsButton], axis: .vertical, spacing: 40)
		
		
		view.addSubview(fillImageView)
		view.addSubview(welcomeLabel)
		view.addSubview(stackView)
		
		
		welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
		fillImageView.translatesAutoresizingMaskIntoConstraints = false
		stackView.translatesAutoresizingMaskIntoConstraints = false
		goToChatsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
		
		
		NSLayoutConstraint.activate([
			welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120)
		])
		
		NSLayoutConstraint.activate([
			fillImageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
			fillImageView .centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
		
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: fillImageView.bottomAnchor, constant: 40),
			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
		])
	}
}

extension UIViewController {
	func showAlert(title: String, message: String, completion: @escaping()->() = {}) {
		let allertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
			completion()
		}
		allertController.addAction(okAction)
		present(allertController, animated: true, completion: nil)
		}
	}




//MARK: - SWIFT UI
import SwiftUI

struct SetupProfileVCProider: PreviewProvider {
	static var previews: some View {
		Group {
			ContainerView().edgesIgnoringSafeArea(.all)
		}
	}
	
	struct ContainerView: UIViewControllerRepresentable {
		let SetupProfileVC = SetupProfileViewController(currentUser: Auth.auth().currentUser!)
		func makeUIViewController(context: UIViewControllerRepresentableContext<SetupProfileVCProider.ContainerView>) -> SetupProfileViewController {
			return SetupProfileVC
		}
		func updateUIViewController(_ uiViewController: SetupProfileViewController, context: Context) {
			
		}
	}
}

