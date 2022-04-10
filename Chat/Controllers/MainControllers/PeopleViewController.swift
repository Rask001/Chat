//
//  PeopleViewController.swift
//  Chat
//
//  Created by Антон on 31.03.2022.
//

import UIKit
import Firebase

class PeopleViewController: UIViewController, UISearchBarDelegate {
	
	let users = [MUser]()
	var collectionView: UICollectionView!
	var dataSource: UICollectionViewDiffableDataSource<Section,MUser>!
	
	enum Section: Int, CaseIterable {
			case  users
		func description(usersCount: Int) -> String {
			switch self {
				case .users:
				return "\(usersCount) people in app"
			}
		}
	}
	
	private let currentUser: MUser
	
	init(currentUser: MUser){
		self.currentUser = currentUser
		super.init(nibName: nil, bundle: nil)
		title = currentUser.username
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .mainWhite()
		setupSearchBar()
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(signOut))
		setupCollectionView()
		createDataSource()
		reloadData(with: nil)
		}
	
	@objc private func signOut() {
		let ac = UIAlertController(title: nil, message: "уверен что хочешь выйти?", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
		ac.addAction(UIAlertAction(title: "sign out", style: .destructive, handler: { _ in
			do {
				try Auth.auth().signOut()
				UIApplication.shared.keyWindow?.rootViewController = AuthViewController()
			} catch {
				print("error signIng out: \(error.localizedDescription)")
			}
		}))
		present(ac, animated: true, completion: nil)
		}
}
	
extension PeopleViewController {
	private func createCompositionLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnviroment) -> NSCollectionLayoutSection? in
			guard let section = Section(rawValue: sectionIndex) else {
				fatalError("Unknow section kind")
			}
			switch section {
			case .users:
				return self.createUsersSection()
			}
		}
		//
		//
		let config = UICollectionViewCompositionalLayoutConfiguration()
		config.interSectionSpacing = 16
		layout.configuration = config
		//изменеие вертикального расстояния между секциями
		return layout
	}
	
	private func createUsersSection() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
																					heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
																					 heightDimension: .fractionalWidth(0.6))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
		let spacing = CGFloat(15)
		group.interItemSpacing = .fixed(spacing)
		let section = NSCollectionLayoutSection(group: group)
		section.interGroupSpacing = spacing
		section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 15, bottom: 0, trailing: 15)
		let sectionHeader = createSectionHeader()
		section.boundarySupplementaryItems = [sectionHeader]
		return section
}
	private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
		let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), //cоздание размера секции хедера
																									 heightDimension: .estimated(1 ))
		let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
																																		elementKind: UICollectionView.elementKindSectionHeader,
																																		alignment: .top)  //настройка секции хедера
		return sectionHeader
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

	private func reloadData(with searchText: String?) { //в качестве входного параметра вносим ?стринг?
		let filtered = users.filter { (user) -> Bool in
			user.contains(filter: searchText)
		}
		
	var snapshot = NSDiffableDataSourceSnapshot<Section, MUser>()
	snapshot.appendSections([.users])
	snapshot.appendItems(filtered , toSection: .users)  //вносимм отфильтрованный массив

	dataSource?.apply(snapshot, animatingDifferences: true)
}
}


extension PeopleViewController {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		reloadData(with: searchText)
	}
}

extension PeopleViewController {
	private func createDataSource() {
		dataSource = UICollectionViewDiffableDataSource<Section, MUser>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
			guard let section = Section(rawValue: indexPath.section) else {
				fatalError("Unknow section kind")
			}
			switch section {
			case .users:

				return self.config(collectionView: collectionView, cellType: UserCell.self, with: user, for: indexPath)
			}
		})
		dataSource?.supplementaryViewProvider = {
			collectionView, kind, indexPath in
			guard let sectionHeader =
							collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else {
				fatalError("Can not create new section header") }
			guard let section = Section(rawValue: indexPath.section) else {
				fatalError("Unknow section kind") }
			let items = self.dataSource.snapshot().itemIdentifiers(inSection: .users) //находим через снэпшот и датусорс пользователей, дажее ниже извлекаем количество
			sectionHeader.configure(text: section.description(usersCount: items.count),
															font: .systemFont(ofSize: 36, weight: .light),
															textColor: .label)
							return sectionHeader
			}
	}
}


extension PeopleViewController {

private func setupCollectionView() {
	collectionView = UICollectionView(frame: view.bounds,
																		collectionViewLayout: createCompositionLayout())
	collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
	collectionView.backgroundColor = .mainWhite()
	view.addSubview(collectionView)

	collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)

	collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseId)
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

