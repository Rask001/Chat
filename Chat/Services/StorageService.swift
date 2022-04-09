//
//  StorageService.swift
//  Chat
//
//  Created by Антон on 09.04.2022.
//

import Foundation
import Firebase

class StorageService {
	static let shared = StorageService()
	let storageRef = Storage.storage().reference()
	private var avatarsRef: StorageReference {
		return storageRef.child("avatars")
	}
	
	private var currentUserId: String {
		return Auth.auth().currentUser!.uid
	}
	
	func upload(photo: UIImage, completion: @escaping (Result<URL,Error>) -> Void) {
		guard let scaledImage = photo.scaledToSafeUploadSize, let imageData = scaledImage.jpegData(compressionQuality: 0.4) else { return }
		let metaData = StorageMetadata()
		metaData.contentType = "image/jpeg"
		avatarsRef.child(currentUserId).putData(imageData, metadata: metaData) { metaData, error in
			guard metaData == metaData else {
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
}
