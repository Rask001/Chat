//
//  UIStackView + extension.swift
//  Chat
//
//  Created by Антон on 29.03.2022.
//

import UIKit

extension UIStackView {
	convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
		self.init(arrangedSubviews: arrangedSubviews)
		self.axis = axis
		self.spacing = spacing
	}
}
