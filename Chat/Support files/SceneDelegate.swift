//
//  SceneDelegate.swift
//  Chat
//
//  Created by Антон on 28.03.2022.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?


	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: windowScene)
	
		if let user = Auth.auth().currentUser {
			FirestoreService.shared.getUserData(user: user) { result in
				
				switch result { //посылаем либо на главный экран либо заполнять инфу о себе
				case .success(let muser):
					let mainTabBar = MainTabBarController(currentUser: muser)
					mainTabBar.modalPresentationStyle = .fullScreen
					self.window?.rootViewController = mainTabBar
					
				case .failure(_):
					self.window?.rootViewController = AuthViewController()
				}
			}
		} else {
			window.rootViewController = AuthViewController()
		}
		
		window.makeKeyAndVisible()
		self.window = window
	}
}

