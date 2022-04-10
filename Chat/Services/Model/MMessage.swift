//
//  MMessage.swift
//  Chat
//
//  Created by Антон on 10.04.2022.
//

import UIKit

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
