//
//  ListenerService.swift
//  Chat
//
//  Created by Антон on 10.04.2022.
//

import Firebase

class ListenerService {
	static let shared = ListenerService()
	private let db = Firestore.firestore()
	private var usersRef: CollectionReference{
		return db.collection("users")
	}
	
	private var currentUserId: String {
		return Auth.auth().currentUser!.uid
	}
	
	//наблюдатель за изменениями пользователей
	func usersObserver(users: [MUser], completion: @escaping (Result<[MUser],Error>) -> Void) -> ListenerRegistration? {
		var users = users
		let usersListener = usersRef.addSnapshotListener{ querySnapshot, error in
			guard let snapshot = querySnapshot else {
				completion(.failure(error!))
				return
			}
			snapshot.documentChanges.forEach { difference in
				guard let muser = MUser(document: difference.document) else { return }
				switch difference.type {
					
				case .added:
					guard !users.contains(muser) else { return }
					guard muser.id != self.currentUserId else { return }
					users.append(muser)
				case .modified:
					guard let index = users.firstIndex(of: muser) else { return }
					users[index] = muser
				case .removed:
					guard let index = users.firstIndex(of: muser) else { return }
					users.remove(at: index)
				}
			}
			completion(.success(users))
		}
		return usersListener
	}
}
