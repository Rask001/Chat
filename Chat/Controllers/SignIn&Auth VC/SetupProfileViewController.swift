//
//  SetupProfileViewController.swift
//  Chat
//
//  Created by Антон on 31.03.2022.
//

import UIKit
import Firebase

class SetupProfileViewController: UIViewController {
	
	
	//MARK: - Properties
	//labels
	let fullImageView = AddPhotoView()
	let welcomeLabel = UILabel(text: "Setup profile", font: .avenir26())
	let fullNameLabel = UILabel(text: "Full name")
	let aboutMeLabel = UILabel(text: "About me")
	let sexLabel = UILabel(text: "sex")
	
	//others
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
	
	
	//MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConstraints()
		buttonTargetsAndDelegate()
		
	}
	
	//MARK: - Methods
	private func buttonTargetsAndDelegate(){
		goToChatsButton.addTarget(self, action: #selector(goToChatsButtonTapped), for: .touchUpInside)
		fullImageView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
		self.fullNameTF.delegate = self
		self.aboutMeTF.delegate = self
	}
	
	@objc private func plusButtonTapped() {
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self
		imagePickerController.sourceType = .photoLibrary
		present(imagePickerController, animated: true, completion: nil)
	}
	
	@objc private func goToChatsButtonTapped() {
		FirestoreService.shared.saveProfileWith(id: currentUser.uid,
																						email: currentUser.email!,
																						username: fullNameTF.text,
																						avatagImage: fullImageView.circleImageView.image,
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


//MARK: - extensions
extension SetupProfileViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
}


//MARK: - Setup constraints
extension SetupProfileViewController {
	private func setupConstraints() {
		
		let fullImageStackView = UIStackView(arrangedSubviews: [fullNameLabel,
																														fullNameTF], axis: .vertical, spacing: 0)
		let aboutMeStackView = UIStackView(arrangedSubviews: [aboutMeLabel,
																													aboutMeTF], axis: .vertical, spacing: 0)
		let sexStackView = UIStackView(arrangedSubviews: [sexLabel,
																											sexSegmentedControl], axis: .vertical, spacing: 12)
		
		let stackView = UIStackView(arrangedSubviews: [fullImageStackView,
																									 aboutMeStackView,
																									 sexStackView,
																									 goToChatsButton], axis: .vertical, spacing: 40)
		
		view.addSubview(fullImageView)
		view.addSubview(welcomeLabel)
		view.addSubview(stackView)
		
		self.view.backgroundColor = .white
		welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
		fullImageView.translatesAutoresizingMaskIntoConstraints = false
		stackView.translatesAutoresizingMaskIntoConstraints = false
		goToChatsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
		
		NSLayoutConstraint.activate([
			welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120)
		])
		
		NSLayoutConstraint.activate([
			fullImageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
			fullImageView .centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
		
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: fullImageView.bottomAnchor, constant: 40),
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

extension SetupProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		picker.dismiss(animated: true, completion: nil)
		guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
		fullImageView.circleImageView.image = image
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

