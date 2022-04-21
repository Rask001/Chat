//
//  StorageService.swift
//  Chat
//
//  Created by Антон on 09.04.2022.
//

import UIKit
import Firebase
import FirebaseStorage

//MARK: - Upload photo to Firestore
class StorageService {
	
//MARK: - Properties
	static let shared = StorageService()
	let storageRef = Storage.storage().reference()
	private var avatarsRef: StorageReference {
		return storageRef.child("avatars")
	}
	private var currentUserId: String {
		return Auth.auth().currentUser!.uid
	}
	
	
	//MARK: - Methods
	func upload(photo: UIImage, completion: @escaping (Result<URL,Error>) -> Void) {
		guard let scaledImage = photo.scaledToSafeUploadSize, let imageData = scaledImage.jpegData(compressionQuality: 0.4) else { return }
		let metaData = StorageMetadata()
		metaData.contentType = "image/jpeg"
		avatarsRef.child(currentUserId).putData(imageData, metadata: metaData) { metaData, error in
			guard let metaData = metaData else {
				completion(.failure(error!))
				return
			}
			self.avatarsRef.child(self.currentUserId).downloadURL { url, error in
				guard let downloadURL = url else {
					completion(.failure(error!))
					return
				}
				completion(.success(downloadURL))
			}
		}
	}
	
	func uploadImageMessage(photo: UIImage, to chat: MChat, completion: @escaping (Result<URL, Error>) -> Void) {
		guard let scaleImage = photo.scaledToSafeUploadSize,
					let imageData = scaleImage.jpegData(compressionQuality: 0.4) else { return }
		
		let metaData = StorageMetadata()
		metaData.contentType = "image/jpeg"

		let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
		let uid: String = Auth.auth().currentUser!.uid
		let chatName = [chat.friendUserName, uid].joined()
		self.storageRef.child(chatName).child(imageName).putData(imageData, metadata: metaData) { (metadata, error) in
			guard metaData != nil else {
				completion(.failure(error!))
				return
			}
			self.storageRef.child(chatName).child(imageName).downloadURL { url, error in
				guard let downloadURL = url else {
					completion(.failure(error!))
					return
				}
				completion(.success(downloadURL))
			}
		}
}
	
	//отоброжение фотографий в чате
	func downloadImage(url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void) {
		let ref = Storage.storage().reference(forURL: url.absoluteString)
		let megaByte = Int64(1 * 1024 * 1024)
		ref.getData(maxSize: megaByte) { data, error in
			guard let imageData = data else {
				completion(.failure(error!))
				return
			}
			completion(.success(UIImage(data: imageData)))
		}
	}
}
