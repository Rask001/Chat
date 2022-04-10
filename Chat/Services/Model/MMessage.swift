//
//  MMessage.swift
//  Chat
//
//  Created by Антон on 10.04.2022.
//

import UIKit
import Firebase

struct MMessage: Hashable {
	let content: String
	let senderId: String
	let senderUsername: String
	var sentData: Date
	let id: String?
	
	init(user: MUser, content: String) {
		self.content = content
		senderId = user.id
		senderUsername = user.username
		sentData = Date()
		id = nil
	}
	
	init?(document: QueryDocumentSnapshot) {
		let data = document.data()
		guard let sentData = data["created"] as? Timestamp else { return nil }
		guard let senderName = data["senderName"] as? String else { return nil }
		guard let content = data["content"] as? String else { return nil }
		guard let senderId = data["senderId"] as? String else { return nil }
		
		self.id = document.documentID
		self.sentData = sentData.dateValue()
		self.senderId = senderId
		self.senderUsername = senderName
		self.content = content
	}
	
	var representation: [String: Any] {
		let rep: [String : Any] = [
			"created" : sentData,
			"senderId" : senderId,
			"senderName" : senderUsername,
			"content" : content
		]
		return rep
	}
}
