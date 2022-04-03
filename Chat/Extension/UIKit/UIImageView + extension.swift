//
//  UIImageView + extension.swift
//  Chat
//
//  Created by Антон on 28.03.2022.
//

import UIKit

extension UIImageView {
	convenience init(image: UIImage?, contentMode: UIView.ContentMode) {
		self.init()
		
		self.image = image
		self.contentMode = contentMode
	}
}

extension UIImageView {
	func setupColor(color: UIColor){
		let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
		self.image = templateImage
		self.tintColor = color
	}
}
