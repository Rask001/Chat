//
//  WaitingChatCell.swift
//  Chat
//
//  Created by Антон on 03.04.2022.
//

import UIKit

class WaitingChatCell: UICollectionViewCell {
	static var reuseId: String = "WaitindChatCell"
	let friendImageView = UIImageView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .systemBlue
		self.layer.cornerRadius = 6
		self.clipsToBounds = true
		setupConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

//MARK: - Setup constraints
extension WaitingChatCell {
	private func setupConstraints() {
		friendImageView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(friendImageView)
		NSLayoutConstraint.activate([
			friendImageView.widthAnchor.constraint(equalToConstant: self.bounds.width),
			friendImageView.heightAnchor.constraint(equalToConstant: self.bounds.height)
		])
	}
}


//MARK: - SelfConfigCellProtocol
extension WaitingChatCell: SelfConfigCellProtocol {
	func configure<U>(with value: U) where U : Hashable {
		guard let chat: MChat = value as? MChat else { return }
//		friendImageView.image = UIImage(named: user.friendAvatarStringURL)
	}
}




//MARK: - SWIFT UI
import SwiftUI

struct WaitingChatProvider: PreviewProvider {
	static var previews: some View {
		Group {
			ContainerView().edgesIgnoringSafeArea(.all)
		}
	}
	
	struct ContainerView: UIViewControllerRepresentable {
		let tabBarVC = MainTabBarController()
		func makeUIViewController(context: UIViewControllerRepresentableContext<WaitingChatProvider.ContainerView>) -> MainTabBarController {
			return tabBarVC
		}
		func updateUIViewController(_ uiViewController: MainTabBarController , context: Context) {
			
		}
	}
}
