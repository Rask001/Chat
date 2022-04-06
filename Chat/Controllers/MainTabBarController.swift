//
//  MainTabBarController.swift
//  Chat
//
//  Created by Антон on 31.03.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
	
	private let currentUser: MUser
	
	init(currentUser: MUser = MUser(username: "default",
																	email: "default",
																	avatarStringURL: "default",
																	description: "default",
																	sex: "default",
																	id: "default")){
		self.currentUser = currentUser
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	let listViewController = ListViewController(currentUser: currentUser)
	let peopleViewController = PeopleViewController(currentUser: currentUser)
	self.tabBar.tintColor = #colorLiteral(red: 0.629904747, green: 0.4648939967, blue: 0.9760698676, alpha: 1)
	let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
	let peopleImage = UIImage(systemName: "person.2", withConfiguration: boldConfig)!
	let convImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfig)!
		
	viewControllers = [
		  generationNavigationController(rootVC: peopleViewController , title: "People", image: peopleImage),
			generationNavigationController(rootVC: listViewController, title: "Conversation", image: convImage)
			
		]
	}
	
	
	
	private func generationNavigationController(rootVC: UIViewController, title: String, image: UIImage) -> UIViewController {
		let navigationVC = UINavigationController(rootViewController: rootVC)
		navigationVC.tabBarItem.title = title
		navigationVC.tabBarItem.image = image
		return navigationVC
	}
}
