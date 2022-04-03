//
//  CustomTextField.swift
//  Chat
//
//  Created by Антон on 03.04.2022.
//

import UIKit

class CustomTextField: UITextField {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = .white
		placeholder = "write something here ..."
		font = UIFont.systemFont(ofSize: 14, weight: .light)
		borderStyle = .none
		clearButtonMode = .whileEditing
		layer.cornerRadius = 18
		layer.masksToBounds = true
		
		let image = UIImage(systemName: "message")
		let imageView = UIImageView(image: image)
		imageView.setupColor(color: .lightGray)
		leftView = imageView
		leftView?.frame = CGRect(x: 0, y: 0, width: 19, height: 19)
		leftViewMode = .always
		
		let button = UIButton(type: .custom)
		button.setImage(UIImage(named: "Sent"), for: .normal)
		rightView = button
		rightView?.frame = CGRect(x: 0, y: 0, width: 19, height: 19)
		rightViewMode = .always
	}
	
	
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: 36, dy: 0)
	}
	override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: 36, dy: 0)
	}
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: 36, dy: 0)
	}
	
	override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
		var rect = super.leftViewRect(forBounds: bounds)
		rect.origin.x += 12
		return rect
	}
	override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
		var rect = super.rightViewRect(forBounds: bounds)
		rect.origin.x += -8
		return rect
	}
	
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
		
	}
}





//MARK: - SWIFT UI
import SwiftUI

struct CustomTextFieldProvider: PreviewProvider {
	static var previews: some View {
		Group {
			ContainerView().edgesIgnoringSafeArea(.all)
		}
	}
	
	struct ContainerView: UIViewControllerRepresentable {
		let profileVC = ProfileViewController()
		func makeUIViewController(context: UIViewControllerRepresentableContext<CustomTextFieldProvider.ContainerView>) -> ProfileViewController {
			return profileVC
		}
		func updateUIViewController(_ uiViewController: ProfileViewController, context: Context) {
			
		}
	}
}
