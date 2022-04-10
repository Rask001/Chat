//
//  ProfileViewController.swift
//  Chat
//
//  Created by Антон on 03.04.2022.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
	//MARK: - Properties
	let containerView = UIView()
	let imageView = UIImageView(image: #imageLiteral(resourceName: "human8"), contentMode: .scaleAspectFill)
	let nameLabel = UILabel (text: "Julia Niked", font: .systemFont(ofSize: 20, weight: .bold))
	let aboutMeLabel = UILabel (text: "I'm Julia, and you?", font: .systemFont(ofSize: 16, weight: .light))
	let myTextField = CustomTextField()
	
	private let user: MUser
	
	init(user: MUser) {
		self.user = user
		self.nameLabel.text = user.username
		self.aboutMeLabel.text = user.description
		self.imageView.sd_setImage(with: URL(string: user.avatarStringURL))
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		customizedElements()
		setupConstraints()
		view.backgroundColor = .white
		self.myTextField.delegate = self
	}
	
	//MARK: - Methods
	//отправка сообщения
	@objc private func sendMessage() {
		print(#function)
		guard let message = myTextField.text, message != "" else { return }
		self.dismiss(animated: true) {
			FirestoreService.shared.createWaitingChat(message: message, receiver: self.user) { result in
				switch result {
					
				case .success():
					UIApplication.getTopViewController()?.showAlert(title: "Успешно!", message: "Ваше сообщение для \(self.user.username) отправлено.")
				case .failure(let error):
					UIApplication.getTopViewController()?.showAlert(title: "Ошибка", message: error.localizedDescription)
				}
			}
		}
	}
}


//MARK: - extension
extension ProfileViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
}

extension ProfileViewController {
	private func customizedElements() {
		containerView.translatesAutoresizingMaskIntoConstraints = false
		imageView.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
		myTextField.translatesAutoresizingMaskIntoConstraints = false
		aboutMeLabel.numberOfLines = 0
		containerView.backgroundColor = .mainWhite()
		containerView.layer.cornerRadius = 30
		
		if let button = myTextField.rightView as? UIButton {
			button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
		}
	}
	
	//MARK: - Setup Constraints
	private func setupConstraints() {
		view.addSubview(imageView)
		view.addSubview(containerView)
		containerView.addSubview(nameLabel)
		containerView.addSubview(aboutMeLabel)
		containerView.addSubview(myTextField)

		NSLayoutConstraint.activate([
			containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			containerView.heightAnchor.constraint(equalToConstant: 206)
	])
		NSLayoutConstraint.activate([
			imageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
			imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			imageView.topAnchor.constraint(equalTo: view.topAnchor)
	])
		NSLayoutConstraint.activate([
			nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 35),
			nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
			nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
	])
		 
		NSLayoutConstraint.activate([
			aboutMeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
			aboutMeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
			aboutMeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
	])
		
		NSLayoutConstraint.activate([
			myTextField.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 8),
			myTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
			myTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
			myTextField.heightAnchor.constraint(equalToConstant: 48)
	])
	}
}

