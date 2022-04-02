//
//  PeopleViewController.swift
//  Chat
//
//  Created by Антон on 31.03.2022.
//

import UIKit

class PeopleViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .mainWhite()
		setupSearchBar()
	}
	
	private func setupSearchBar() {
//		navigationController?.navigationBar.barTintColor = .mainWhite()
//		navigationController?.navigationBar.shadowImage = UIImage()
		let searchController = UISearchController(searchResultsController:  nil)
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.delegate = self
		}
	
	
}


extension PeopleViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		print(searchText)
	}
}





//MARK: - SWIFT UI
import SwiftUI

struct PeopleVCProvider: PreviewProvider {
	static var previews: some View {
		Group {
			ContainerView().edgesIgnoringSafeArea(.all)
		}
	}
	
	struct ContainerView: UIViewControllerRepresentable {
		let tabBarVC = MainTabBarController()
		func makeUIViewController(context: UIViewControllerRepresentableContext<PeopleVCProvider.ContainerView>) -> MainTabBarController {
			return tabBarVC
		}
		func updateUIViewController(_ uiViewController: MainTabBarController , context: Context) {
			
		}
	}
}
