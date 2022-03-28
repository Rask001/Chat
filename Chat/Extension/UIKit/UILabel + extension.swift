//
//  UILabel + extension.swift
//  Chat
//
//  Created by Антон on 28.03.2022.
//

import UIKit

extension UILabel {
	
	convenience init(text : String, font: UIFont? = .avenir20()) {
		self.init()
		self.text = text
		self.font = font
	}
}
