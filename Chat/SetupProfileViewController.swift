//
//  SetupProfileViewController.swift
//  Chat
//
//  Created by Антон on 31.03.2022.
//

import UIKit

class SetupProfileViewController: UIViewController {
	
	let fillImageView = AddPhotoView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConstraints()
		view.backgroundColor = .white
	}
	
}





extension SetupProfileViewController {
	private func setupConstraints() {
		
		fillImageView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(fillImageView)
		
		NSLayoutConstraint.activate([
			fillImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
			fillImageView .centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
	}
}

//MARK: - SWIFT UI
import SwiftUI

struct SetupProfileVCProider: PreviewProvider {
	static var previews: some View {
		Group {
			ContainerView().edgesIgnoringSafeArea(.all)
		}
	}
	
	struct ContainerView: UIViewControllerRepresentable {
		let SetupProfileVC = SetupProfileViewController()
		func makeUIViewController(context: UIViewControllerRepresentableContext<SetupProfileVCProider.ContainerView>) -> SetupProfileViewController {
			return SetupProfileVC
		}
		func updateUIViewController(_ uiViewController: SetupProfileViewController, context: Context) {
			
		}
	}
}

