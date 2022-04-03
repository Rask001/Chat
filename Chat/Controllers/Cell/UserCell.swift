//
//  UserCell.swift
//  Chat
//
//  Created by Антон on 03.04.2022.
//

import UIKit

class UserCell: UICollectionViewCell {
	
	let userImageView = UIImageView()
	let userName = UILabel(text: "Petya", font: .laoSangamMN20())
	let containerView = UIView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .white
		setupConstraints()
		self.layer.cornerRadius = 6
		self.layer.shadowColor = #colorLiteral(red: 0.741176486, green: 0.741176486, blue: 0.741176486, alpha: 1)
		self.layer.shadowRadius = 4
		self.layer.shadowOpacity = 0.5
		self.layer.shadowOffset = CGSize(width: 0, height: 4)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.containerView.layer.cornerRadius = 6
		self.containerView.clipsToBounds = true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupConstraints(){
		userImageView.translatesAutoresizingMaskIntoConstraints = false
		userName.translatesAutoresizingMaskIntoConstraints = false
		containerView.translatesAutoresizingMaskIntoConstraints = false
		
		userImageView.backgroundColor = .red
		
	  addSubview(containerView)
		containerView.addSubview(userImageView)
		containerView.addSubview(userName)
		
		NSLayoutConstraint.activate([
			containerView.widthAnchor.constraint(equalToConstant: self.bounds.width),
			containerView.heightAnchor.constraint(equalToConstant: self.bounds.height)
		])
		
		NSLayoutConstraint.activate([
			userImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
			userImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
			userImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
			userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor)
		])
		
		NSLayoutConstraint.activate([
			userName.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 0),
			userName.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
			userName.widthAnchor.constraint(equalTo: containerView.widthAnchor)
		])
	}
	
	
}


extension UserCell: SelfConfigCellProtocol {
	static var reuseId: String = "UserCell"
	func configure<U>(with value: U) where U : Hashable {
		guard let user: MUser = value as? MUser else { return }
		userImageView.image = UIImage(named: user.avatarStringURL)
		userName.text = user.username
		
	}
}



//MARK: - SWIFT UI
import SwiftUI

struct UserCellProvider: PreviewProvider {
	static var previews: some View {
		Group {
			ContainerView().edgesIgnoringSafeArea(.all)
		}
	}
	
	struct ContainerView: UIViewControllerRepresentable {
		let tabBarVC = MainTabBarController()
		func makeUIViewController(context: UIViewControllerRepresentableContext<UserCellProvider.ContainerView>) -> MainTabBarController {
			return tabBarVC
		}
		func updateUIViewController(_ uiViewController: MainTabBarController , context: Context) {
			
		}
	}
}
