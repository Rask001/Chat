//
//  ListViewController.swift
//  Chat
//
//  Created by Антон on 31.03.2022.
//
import UIKit
import Firebase

class ListViewController: UIViewController {
	
//	let activeChats = Bundle.main.decode([MChat].self, from: "activeChats.json")
//	let waitingChats = Bundle.main.decode([MChat].self, from: "waitingChats.json")
	
	//MARK: - Properties
	var activeChats = [MChat]()
	var waitingChats = [MChat]()
	
		var dataSource: UICollectionViewDiffableDataSource<Section, MChat>?
		var collectionView: UICollectionView!
	
	private var waitingChatsListener: ListenerRegistration?
	private var activeChatsListener: ListenerRegistration?
	
	enum Section: Int, CaseIterable {
			case  waitingChats, activeChats
		
		func description() -> String {
			switch self {
			case .waitingChats:
				return "Waiting chats"
			case .activeChats:
				return "Active chats"
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
	
	deinit {
		waitingChatsListener?.remove()
		activeChatsListener?.remove()
	}
	
	
	//MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupSearchBar()
		setupCollectionView()
		createDataSource()
		reloadData()
		
		waitingChatsListener = ListenerService.shared.waitingChatsObserver(chats: waitingChats, completion: { result in
			switch result {
			case .success(let chats):
				if self.waitingChats != [], self.waitingChats.count <= chats.count {
					let chatRequestVC = ChatRequestViewController(chat: chats.last!)
					chatRequestVC.delegate = self
					self.present(chatRequestVC, animated: true, completion: nil)
				}
				self.waitingChats = chats
				self.reloadData()
			case .failure(let error):
				self.showAlert(title: "Ошибка", message: error.localizedDescription)
			}
		})
		activeChatsListener = ListenerService.shared.activeChatsObserver(chats: activeChats, completion: { result in
			switch result {
			case .success(let chats):
				self.activeChats = chats
				self.reloadData()
			case .failure(let error):
				self.showAlert(title: "Ошибка", message: error.localizedDescription)
			}
		})
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
	
		collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
		
		collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseId)
		collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseId)
		collectionView.delegate = self
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
				return self.config(collectionView: collectionView, cellType: ActiveChatCell.self, with: chat, for: indexPath)
			case .waitingChats:
				return self.config(collectionView: collectionView, cellType: WaitingChatCell.self, with: chat, for: indexPath)
			}
		})
		dataSource?.supplementaryViewProvider = {
			collectionView, kind, indexPath in
			guard let sectionHeader =
							collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else {
				fatalError("Can not create new section header") }
			guard let section = Section(rawValue: indexPath.section) else {
				fatalError("Unknow section kind") }
			sectionHeader.configure(text: section.description(),
															font: .laoSangamMN20(),
															textColor: .lightGray)
							return sectionHeader
			}
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
		//
		//
		let config = UICollectionViewCompositionalLayoutConfiguration()
		config.interSectionSpacing = 16
		layout.configuration = config
		//изменеие вертикального расстояния между секциями
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
    let sectionHeader = createSectionHeader()
		section.boundarySupplementaryItems = [sectionHeader] //вставляем в массив результат функции
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
		let sectionHeader = createSectionHeader()
		section.boundarySupplementaryItems = [sectionHeader] //вставляем в массив результат функции
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
}


//MARK: - UICollectionViewDelegate
extension ListViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let chat = self.dataSource?.itemIdentifier(for: indexPath) else { return }
		guard let section = Section(rawValue: indexPath.section) else { return }
		switch section {
		case .waitingChats:
			let chatRequestVC = ChatRequestViewController(chat: chat)
			chatRequestVC.delegate = self
			self.present(chatRequestVC, animated: true, completion: nil)
		case .activeChats:
			let chatsVC = ChatsViewController(user: currentUser, chat: chat)
			navigationController?.pushViewController(chatsVC, animated: true)
		}
	}
}

extension ListViewController: WaitingChatNavigationsProtocol {
	func removeWaitingChat(chat: MChat) {
		FirestoreService.shared.deleteWaitingChat(chat: chat) { result in
			switch result {
			case .success:
				self.showAlert(title: "Успешно!", message: "Чат с \(chat.friendUserName) был удален ")
			case .failure(let error):
				self.showAlert(title: "Ошибка", message: error.localizedDescription)
			}
		}
	}
	
	func changeToActive(chat: MChat) {
		FirestoreService.shared.changeToActive(chat: chat) { result in
			switch result {
			case .success():
				self.showAlert(title: "Успешно!", message: "Приятного общения с \(chat.friendUserName)")
			case .failure(let error):
				self.showAlert(title: "Ошибка!", message: error.localizedDescription)
			}
		}
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
