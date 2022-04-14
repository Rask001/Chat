//
//  MMessage.swift
//  Chat
//
//  Created by Антон on 10.04.2022.
//

import UIKit
import Firebase
import MessageKit

struct MMessage: Hashable, MessageType { //подписав модель под протокол MessageType потребуется дозаполнить/изменить необходимые свойтва
	
	let content: String
	var sender: SenderType
	var sentDate: Date
	let id: String?
	var messageId: String {
		return id ?? UUID().uuidString
	}
	var kind: MessageKind {
		return .text(content)
	}
	
	
	
	init(user: MUser, content: String) {
		self.content = content
		sender = Sender(senderId: user.id, displayName: user.username)
		sentDate = Date()
		id = nil
	}
	
	init?(document: QueryDocumentSnapshot) {
		let data = document.data()
		guard let sentDate = data["created"] as? Timestamp else { return nil }
		guard let senderName = data["senderName"] as? String else { return nil }
		guard let content = data["content"] as? String else { return nil }
		guard let senderId = data["senderId"] as? String else { return nil }
		
		self.id = document.documentID
		self.sentDate = sentDate.dateValue()
		sender = Sender(senderId: senderId, displayName: senderName)
		self.content = content
	}
	
	var representation: [String: Any] {
		let rep: [String : Any] = [
			"created" : sentDate,
			"senderId" : sender.senderId,
			"senderName" : sender.displayName,
			"content" : content
		]
		return rep
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(messageId)
	}
	
	static func == (lhs: MMessage, rhs: MMessage) -> Bool {
		return lhs.messageId == rhs.messageId
	}
}

extension MMessage: Comparable {
	static func < (lhs: MMessage, rhs: MMessage) -> Bool {
		return lhs.sentDate < rhs.sentDate
	}
	
}
