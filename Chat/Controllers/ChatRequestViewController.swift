//
//  ChatRequestViewController.swift
//  Chat
//
//  Created by Антон on 03.04.2022.
//

import UIKit

class ChatRequestViewController: UIViewController{
	
	let containerView = UIView()
	let imageView = UIImageView(image: #imageLiteral(resourceName: "human8"), contentMode: .scaleAspectFill)
	let nameLabel = UILabel (text: "Julia Niked", font: .systemFont(ofSize: 20, weight: .bold))
	let aboutMeLabel = UILabel (text: "You have to opportunity to start a new chat", font: .systemFont(ofSize: 16, weight: .light))
	let acceptButton = UIButton(backrounColor: .black, titleColor: .white, title: "ACCEPT", isShadow: false, font: .laoSangamMN20(), cornerRaadius: 10)
	let denyButton = UIButton(backrounColor: .mainWhite(), titleColor: #colorLiteral(red: 0.8756850362, green: 0.2895075083, blue: 0.2576965988, alpha: 1), title: "Deny", isShadow: false, font: .laoSangamMN20(), cornerRaadius: 10)
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .mainWhite()
		customixeElements()
		setupConstraints()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewWillLayoutSubviews()
		self.acceptButton.applyGradients(cornerRadius: 10)
	}
}


extension ChatRequestViewController {
		private func customixeElements() {
			containerView.translatesAutoresizingMaskIntoConstraints = false
			imageView.translatesAutoresizingMaskIntoConstraints = false
			nameLabel.translatesAutoresizingMaskIntoConstraints = false
			aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
			denyButton.layer.borderWidth = 1.2
			denyButton.layer.borderColor = #colorLiteral(red: 0.8756850362, green: 0.2895075083, blue: 0.2576965988, alpha: 1)
			containerView.backgroundColor = .mainWhite()
			containerView.layer.cornerRadius = 30
		}
		
	
		private func setupConstraints() {
			view.addSubview(imageView)
			view.addSubview(containerView)
			containerView.addSubview(nameLabel)
	   	containerView.addSubview(aboutMeLabel)
			let buttonsStackView = UIStackView(arrangedSubviews: [acceptButton, denyButton],
																				 axis: .horizontal,
																				 spacing: 7)
			buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
			buttonsStackView.distribution = .fillEqually
	    containerView.addSubview(buttonsStackView)
			
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
				buttonsStackView.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 24),
				buttonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
				buttonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
				buttonsStackView.heightAnchor.constraint(equalToConstant: 56)
		])
	}
}








//MARK: - SWIFT UI
import SwiftUI

struct ChatRequestVCProvider: PreviewProvider {
	static var previews: some View {
		Group {
			ContainerView().edgesIgnoringSafeArea(.all)
		}
	}
	
	struct ContainerView: UIViewControllerRepresentable {
		let ChatRequestVC = ChatRequestViewController()
		func makeUIViewController(context: UIViewControllerRepresentableContext<ChatRequestVCProvider.ContainerView>) -> ChatRequestViewController {
			return ChatRequestVC
		}
		func updateUIViewController(_ uiViewController: ChatRequestViewController , context: Context) {
			
		}
	}
}
