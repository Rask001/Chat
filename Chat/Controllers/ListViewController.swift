//
//  ListViewController.swift
//  Chat
//
//  Created by Антон on 31.03.2022.
//
import UIKit

class ListViewController: UIViewController {
	
//	let activeChats = Bundle.main.decode([MChat].self, from: "activeChats.json")
//	let waitingChats = Bundle.main.decode([MChat].self, from: "waitingChats.json")
	
	
	let activeChats = reedJson(name: "activeChats")
	let waitingChats = reedJson(name: "waitingChats")
	
	enum Section: Int, CaseIterable {
			case  waitingChats, activeChats
	}

	//MARK: - Properties
		var dataSource: UICollectionViewDiffableDataSource<Section, MChat>?
	  var collectionView: UICollectionView!
	
	
	//MARK: - ViewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		setupSearchBar()
		setupCollectionView()
		createDataSource()
		reloadData()
	}
	
	private func setupSearchBar() {
//		navigationController?.navigationBar.barTintColor = .mainWhite()
//		navigationController?.navigationBar.shadowImage = UIImage()
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
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellid2")
	}
	
	private func reloadData() {
	var snapshot = NSDiffableDataSourceSnapshot<Section, MChat>()
	snapshot.appendSections([.waitingChats, .activeChats])
	snapshot.appendItems(activeChats, toSection: .activeChats)
	snapshot.appendItems(waitingChats, toSection: .waitingChats)
	dataSource?.apply(snapshot, animatingDifferences: true)
}
}



// MARK: - Data Source
extension ListViewController {
	private func createDataSource() {
		dataSource = UICollectionViewDiffableDataSource<Section, MChat>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, chat) -> UICollectionViewCell? in
			guard let section = Section(rawValue: indexPath.section) else {
				fatalError("Unknown section kind")
			}
			
			switch section {
			case .activeChats:
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath)
				cell.backgroundColor = .systemBlue
				return cell
			case .waitingChats:
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid2", for: indexPath)
				cell.backgroundColor = .systemRed
				return cell
			}
		})
	}
}

//MARK: - Create Composition Layout
extension ListViewController {
	
	private func createCompositionLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnviroment) -> NSCollectionLayoutSection? in
			guard let section = Section(rawValue: sectionIndex) else {
				fatalError("Unknow section kind")
			}
			switch section {
			case .waitingChats:
				return self.createWaitingChats()
			case .activeChats:
				return self.createActiveChats()
			}
		}
		return layout
	}
	
	private func createWaitingChats() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), //дробная высота, сколько айтемов будет в группе вертикально. если 0.5 то будет 2 айтема
																					heightDimension: .fractionalHeight(1)) //приблизительное значение
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(88), heightDimension: .absolute(88))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item]) //создаем группу
		let section = NSCollectionLayoutSection(group: group) //добавляем в секцию нашу группу
		section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 20, bottom: 0, trailing: 20)
		section.interGroupSpacing = 16
		section.orthogonalScrollingBehavior = .continuous
		return section
	}
	
	private func createActiveChats() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), //дробная высота, сколько айтемов будет в группе вертикально. если 0.5 то будет 2 айтема
																					heightDimension: .fractionalHeight(1)) //приблизительное значение
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
																					 heightDimension: .absolute(78))
		let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item]) //создаем группу
		let section = NSCollectionLayoutSection(group: group) //добавляем в секцию нашу группу
		section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 20, bottom: 0, trailing: 20)
		section.interGroupSpacing = 8
		return section
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
