//
//  UIView + exstension.swift
//  Chat
//
//  Created by Антон on 04.04.2022.
//

import UIKit

extension UIView {
	func applyGradients(cornerRadius: CGFloat) {
		self.backgroundColor = nil
		self.layoutIfNeeded()
		let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: #colorLiteral(red: 0.8309458494, green: 0.7057176232, blue: 0.9536159635, alpha: 1), endColor: #colorLiteral(red: 0.4032760262, green: 0.7716199756, blue: 1, alpha: 1))
		if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
			gradientLayer.frame = self.bounds
			gradientLayer.cornerRadius = cornerRadius
		self.layer.insertSublayer(gradientLayer, at: 0)
		}
	}
}
