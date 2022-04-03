//
//  SectionHeader.swift
//  Chat
//
//  Created by Антон on 03.04.2022.
//

import UIKit


class SectionHeader: UICollectionReusableView {
	
	static let reuseId = "SectionHeader"
	let title = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		title.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(title)
		
		NSLayoutConstraint.activate([
			title.widthAnchor.constraint(equalTo: self.widthAnchor),
			title.heightAnchor.constraint(equalTo : self.heightAnchor)
		])
	}
	
	func configure(text: String, font: UIFont?, textColor: UIColor){
		title.font = font
		title.text = text
		title.textColor = textColor
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
}
