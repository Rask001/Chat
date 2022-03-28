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
