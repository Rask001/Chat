//
//  UIButton+Extantion.swift
//  Chat
//
//  Created by Антон on 28.03.2022.
//

import Foundation
import UIKit

extension UIButton {
	convenience init(backrounColor: UIColor,
									 titleColor: UIColor,
									 title: String,
									 isShadow: Bool = false,
									 font: UIFont? = .avenir20(),
									 cornerRaadius: CGFloat = 4) {
		self.init(type: .system)
		self.setTitle(title, for: .normal)
		self.setTitleColor(titleColor, for: .normal)
		self.backgroundColor = backrounColor
		self.titleLabel?.font = font
		self.layer.cornerRadius = cornerRaadius
		
		if isShadow == true {
			self.layer.shadowColor = UIColor.black.cgColor
			self.layer.shadowRadius = 4
			self.layer.shadowOpacity = 0.2
			self.layer.shadowOffset = CGSize(width: 0, height: 4 )
			
		}
	}
	
	func customizeGoogleButton() {
		let googleLogo = UIImageView(image: #imageLiteral(resourceName: "googleLogo"), contentMode: .scaleAspectFit)
		googleLogo.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(googleLogo)
		googleLogo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24).isActive = true
		googleLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
	}
	
}
