//
//  SetupProfileViewController.swift
//  Chat
//
//  Created by Антон on 31.03.2022.
//

import UIKit

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
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConstraints()
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




//MARK: - SWIFT UI
import SwiftUI

struct SetupProfileVCProider: PreviewProvider {
	static var previews: some View {
		Group {
			ContainerView().edgesIgnoringSafeArea(.all)
		}
	}
	
	struct ContainerView: UIViewControllerRepresentable {
		let SetupProfileVC = SetupProfileViewController()
		func makeUIViewController(context: UIViewControllerRepresentableContext<SetupProfileVCProider.ContainerView>) -> SetupProfileViewController {
			return SetupProfileVC
		}
		func updateUIViewController(_ uiViewController: SetupProfileViewController, context: Context) {
			
		}
	}
}

