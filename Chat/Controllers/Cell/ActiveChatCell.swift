//
//  Cell.swift
//  Chat
//
//  Created by Антон on 03.04.2022.
//

import UIKit

//MARK: - ActiveChatCell
class ActiveChatCell: UICollectionViewCell {
	static var reuseId: String = "ActiveChatCell"
	
	let friendImageView = UIImageView()
	let friendName = UILabel(text: "User name", font: .laoSangamMN20())
	let lastMessage = UILabel(text: "How are you? ", font: .laoSangamMN18())
	let gradientVew = GradientView(from: .topLeading, to: .bottomTrailing, startColor: #colorLiteral(red: 0.8309458494, green: 0.7057176232, blue: 0.9536159635, alpha: 1), endColor: #colorLiteral(red: 0.4032760262, green: 0.7716199756, blue: 1, alpha: 1))
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


//MARK: - Setup constraints
extension ActiveChatCell {
	private func setupConstraints() {
		self.backgroundColor = .white
		self.layer.cornerRadius = 6
		self.clipsToBounds = true //обрезает верхние слоя под радиус нижнего
		gradientVew.backgroundColor = .black
		friendImageView.translatesAutoresizingMaskIntoConstraints = false
		gradientVew.translatesAutoresizingMaskIntoConstraints = false
		lastMessage.translatesAutoresizingMaskIntoConstraints = false
		friendName.translatesAutoresizingMaskIntoConstraints = false
		
		friendImageView.backgroundColor = .systemYellow
		
		self.addSubview(friendImageView)
		self.addSubview(gradientVew)
		self.addSubview(friendName)
		self.addSubview(lastMessage)
		NSLayoutConstraint.activate([
			friendImageView.widthAnchor.constraint(equalToConstant: 78),
			friendImageView.heightAnchor.constraint(equalToConstant: 78),
			friendImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
		])
		
		NSLayoutConstraint.activate([
			gradientVew.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
			gradientVew.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			gradientVew.heightAnchor.constraint(equalToConstant: 78),
			gradientVew.widthAnchor.constraint(equalToConstant: 8)
		])
		
		NSLayoutConstraint.activate([
			friendName.topAnchor.constraint(equalTo: self.topAnchor, constant: 11 ),
			friendName.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
			friendName.trailingAnchor.constraint(equalTo: gradientVew.leadingAnchor, constant: 16)
		])
		
		NSLayoutConstraint.activate([
			lastMessage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -11),
			lastMessage.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
			lastMessage.trailingAnchor.constraint(equalTo: gradientVew.leadingAnchor, constant: 16)
		])
	}
}

//MARK: - Self configuring cell
extension ActiveChatCell: SelfConfigCellProtocol {
	
	func configure<U>(with value: U) where U : Hashable {
		guard let chat: MChat = value as? MChat else { return }
		friendImageView.image = UIImage(named: chat.userImageString)
		friendName.text = chat.username
		lastMessage.text = chat.lastMessage
	}
}
	
	








//MARK: - SWIFT UI
import SwiftUI

struct ActiveChatProvider: PreviewProvider {
	static var previews: some View {
		Group {
			ContainerView().edgesIgnoringSafeArea(.all)
		}
	}
	
	struct ContainerView: UIViewControllerRepresentable {
		let tabBarVC = MainTabBarController()
		func makeUIViewController(context: UIViewControllerRepresentableContext<ActiveChatProvider.ContainerView>) -> MainTabBarController {
			return tabBarVC
		}
		func updateUIViewController(_ uiViewController: MainTabBarController , context: Context) {
			
		}
	}
}

