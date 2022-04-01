//
//  ListViewController.swift
//  Chat
//
//  Created by Антон on 31.03.2022.
//

import UIKit

struct MCaht: Hashable {
	var userName: String
	var lastMessage: String
	var userIamge: UIImage
	var id = UUID()
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	static func == (lhs: MCaht, rhs: MCaht) -> Bool {
		return lhs.id == rhs.id
	}
}

class ListViewController: UIViewController {
	
	
	
	//MARK: - Properties
	var collectionView: UICollectionView!
	enum Section: Int, CaseIterable {
		case activeChats
	}
	var dataSource: UICollectionViewDiffableDataSource<Section, MCaht>?
	let activeChats: [MCaht] = [
		MCaht(userName: "Antony", lastMessage: "sup?", userIamge: UIImage(systemName: "person.crop.rectangle.stack.fill")!),
		
			MCaht(userName: "Jack", lastMessage: "sup?", userIamge: UIImage(systemName: "person.crop.rectangle.fill")!),
			
				MCaht(userName: "Kristina", lastMessage: "sup?", userIamge: UIImage(systemName: "person.crop.square.filled.and.at.rectangle")!)
		
	]
	
	//MARK: - ViewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		setupSearchBar()
		setupCollectionView()
		createDataSource()
		reloadData()
	}

	
	private func setupView(){
		view.backgroundColor = .mainWhite()
	}
	
	private func setupSearchBar() {
		let searchController = UISearchController(searchResultsController:  nil)
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		searchController.hidesNavigationBarDuringPresentation = false //скрывает панель нави во время презентации
		searchController.obscuresBackgroundDuringPresentation = false //скрывается ли содержимое поиска в презентеции
		searchController.searchBar.delegate = self
	}
	
	private func setupCollectionView() {
		collectionView = UICollectionView(frame: view.bounds,
																			collectionViewLayout: createCompositionLayout())
		collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		collectionView.backgroundColor = .mainWhite()
		view.addSubview(collectionView)
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellid")
	}
	
	private func createDataSource() {
		dataSource = UICollectionViewDiffableDataSource<Section, MCaht>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, chat) -> UICollectionViewCell? in
			guard let section = Section(rawValue: indexPath.section) else {
				fatalError("Unknow section kind")
			}
		
			switch section {
			case .activeChats:
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath)
				cell.backgroundColor = .systemBlue
				cell.layer.cornerRadius = 10
				 return cell
			}
		})
	}
	
	private func reloadData(){
		var snapshot = NSDiffableDataSourceSnapshot<Section, MCaht>()
		snapshot.appendSections([.activeChats])
		snapshot.appendItems(activeChats, toSection: .activeChats)
		dataSource?.apply(snapshot, animatingDifferences: true)
	}
																																		
private func createCompositionLayout() -> UICollectionViewLayout {
	  let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnviroment) -> NSCollectionLayoutSection? in
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), //дробная высота, сколько айтемов будет в группе вертикально. если 0.5 то будет 2 айтема
																					heightDimension: .fractionalHeight(1)) //приблизительное значение
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(84))
			let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item]) //создаем группу
			group.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 5, trailing: 0)
			let section = NSCollectionLayoutSection(group: group) //добавляем в секцию нашу группу
			section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 20, bottom: 0, trailing: 20)
		return section
	}
	return layout
}
}


//MARK: - Extension SearchBarDelegate
extension ListViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		print(searchText)
	}
}






//MARK: - SWIFT UI
import SwiftUI

struct ListVCProvider: PreviewProvider {
	static var previews: some View {
		Group {
			ContainerView().edgesIgnoringSafeArea(.all)
		}
	}
	
	struct ContainerView: UIViewControllerRepresentable {
		let tabBarVC = MainTabBarController()
		func makeUIViewController(context: UIViewControllerRepresentableContext<ListVCProvider.ContainerView>) -> MainTabBarController {
			return tabBarVC
		}
		func updateUIViewController(_ uiViewController: MainTabBarController , context: Context) {
			
		}
	}
}
