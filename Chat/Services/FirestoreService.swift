//
//  FirestoreService.swift
//  Chat
//
//  Created by Антон on 04.04.2022.
//

import Firebase
import UIKit
import SwiftUI


class FirestoreService {
	
	//MARK: - Properties
	static let shared = FirestoreService()
	let db = Firestore.firestore()
	var usersRef: CollectionReference {
		return db.collection("users")
	}
	var currentUser: MUser!
	private var waitingChatsRef: CollectionReference {
		return db.collection(["users", currentUser.id, "waitingChats"].joined(separator: "/"))
	}
	
	private var activeChatsRef: CollectionReference {
		return db.collection(["users", currentUser.id, "activeChats"].joined(separator: "/"))
	}
	
	//MARK: - Methods
	//достаем информацию по юзеру через uid
	func getUserData(user: User, completion: @escaping (Result<MUser, Error>) -> Void) {
		let docRef = usersRef.document(user.uid)
		docRef.getDocument { document, error in
			if let document = document, document.exists {
				guard let muser = MUser(document: document) else {
					completion(.failure(UserError.cannotUnwrapToMUser))
					return
				}
				self.currentUser = muser
				completion(.success(muser))
			} else {
				completion(.failure(UserError.userNotExist))
			}
		}
	}
	//кладем информацию в фаирстор
	func saveProfileWith(id: String, email: String, username: String?, avatagImage: UIImage?, description: String?, sex: String?, completion: @escaping (Result<MUser, Error>) -> Void) {
		guard Validators.isFilled(username: username, description: description, sex: sex) else {
			completion(.failure(UserError.notFilled))
			return
		}
		guard avatagImage != #imageLiteral(resourceName: "avatar") else {
			completion(.failure(UserError.photoNotExist))
			return
		}
		var muser = MUser(username: username!,
											email: email,
											avatarStringURL: "not exist",
											description: description!,
											sex: sex!,
											id: id)
		StorageService.shared.upload(photo: avatagImage!) { result in
			switch result {
			case .success(let url):
				muser.avatarStringURL = url.absoluteString
				self.usersRef.document(muser.id).setData(muser.representation) { error in
					if let error = error {
						completion(.failure(error))
					} else {
						completion(.success(muser))
					}
				}
			case .failure(let error):
				completion(.failure(error))
			}
		} //StorageService
	}//saveProfileWith
	
	
	//создание ожидающих чатов
	func createWaitingChat(message: String, receiver: MUser, completion: @escaping (Result<Void, Error>) -> Void) {
		let reference = db.collection(["users", receiver.id, "waitingChats"].joined(separator: "/"))
		let messageRef = reference.document(self.currentUser.id).collection("messages")
		let message = MMessage(user: currentUser, content: message)
		let chat = MChat(friendUserName: currentUser.username,
										 friendAvatarStringURL: currentUser.avatarStringURL,
										 lastMessageContent: message.content,
										 friendId: currentUser.id)
		
		reference.document(currentUser.id).setData(chat!.representation) { error in
			if let error = error {
				completion(.failure(error))
				return
			}
			messageRef.addDocument(data: message.representation) { error in
				if let error = error {
					completion(.failure(error))
					return
				}
				completion(.success(Void()))
			}
		}
	}
	func deleteWaitingChat(chat: MChat, completion: @escaping (Result<Void,Error>) -> Void) {
		waitingChatsRef.document(chat.friendId).delete { error in
			if let error = error {
				completion(.failure(error))
				return
			}
			self.deleteMessages(chat: chat, completion: completion)
		}
	}
	
	func deleteMessages(chat: MChat, completion: @escaping (Result <Void, Error>) -> Void){
		let reference = waitingChatsRef.document(chat.friendId).collection("messages")
		getWaitingChatMessages(chat: chat) { result in
			switch result {
			case .success(let messages):
				for message in messages {
					guard let documentId = message.id else { return }
					let messageRef = reference.document(documentId)
					messageRef.delete { error in
						if let error = error {
							completion(.failure(error))
							return
					}
						completion(.success(Void()))
				}
			}
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	func getWaitingChatMessages(chat: MChat, completion: @escaping (Result <[MMessage], Error>) -> Void) {
		let reference = waitingChatsRef.document(chat.friendId).collection("messages")
		var messages = [MMessage]()
		reference.getDocuments { querySnapshot, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			for document in querySnapshot!.documents {
				guard let message = MMessage(document: document) else { return }
				messages.append(message)
			}
			completion(.success(messages))
		}
	}
	
		func changeToActive(chat: MChat, completion: @escaping (Result <Void, Error>) -> Void){
			getWaitingChatMessages(chat: chat) { result in
				switch result {
				case .success(let messages):
					self.deleteWaitingChat(chat: chat) { result in
						switch result {
						case .success():
							self.createActiveChat(chat: chat, messages: messages) { result in
								switch result {
								case .success():
									completion(.success(Void()))
								case .failure(let error):
									completion(.failure(error))
								}
							}
						case .failure(let error):
							completion(.failure(error))
						}
					}
				case .failure(let error):
					completion(.failure(error))
				}
			}
		}
		
		func createActiveChat(chat: MChat, messages:  [MMessage], completion: @escaping (Result <Void, Error>) -> Void) {
			let messageRef = activeChatsRef.document(chat.friendId).collection("messages")
			activeChatsRef.document(chat.friendId).setData(chat.representation) { error in
				if let error = error {
					completion(.failure(error))
					return
				}
				for message in messages {
					messageRef.addDocument(data: message.representation) { error in
						if let error = error {
							completion(.failure(error))
							return
					 }
						completion(.success(Void()))
				}
			}
		}
	}
	
	
	func sentMessage(chat: MChat, message: MMessage, completion: @escaping (Result <Void, Error>) -> Void) { //отправка сообщений
		//добираемся до активного чата собеседника с текушим юзером (нами)
		let friendRef = usersRef.document(chat.friendId).collection("activeChats").document(currentUser.id)
		//добираемся до сообщений в активном чате у друга
		let friendMessageRef = friendRef.collection("messages")
		//референс на свои сообщения
		let myMessageRef = usersRef.document(currentUser.id).collection("activeChats").document(chat.friendId).collection("messages")
		
		//3 ссылки готовы, теперь добвавляем нужную информацию в них
		guard let chatForFriend = MChat(friendUserName: currentUser.username,
															friendAvatarStringURL: currentUser.avatarStringURL,
															lastMessageContent: message.content,
																		friendId: currentUser.id) else { return }
		

		friendRef.setData(chatForFriend.representation) { error in
			if let error = error {
				completion(.failure(error))
				return
			}
			friendMessageRef.addDocument(data: message.representation) { error in
				if let error = error {
					completion(.failure(error))
					return
				}
				myMessageRef.addDocument(data: message.representation) { error in
					if let error = error {
						completion(.failure(error))
						return
					}
					completion(.success(Void()))
				}
			}
		}
	}
}

