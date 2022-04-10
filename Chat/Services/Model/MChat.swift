//
//  ModelData.swift
//  Chat
//
//  Created by Антон on 02.04.2022.
//
import Foundation
import Firebase

struct MChat: Hashable, Decodable {
	var friendUserName: String
	var friendAvatarStringURL: String
	var lastMessageContent : String?
	var friendId: String

	var representation: [String: Any] {
		var rep = ["frientUserName" : friendUserName]
		rep["friendAvatarStringURL"] = friendAvatarStringURL
		rep["lastMessage"] = lastMessageContent
		rep["friendId"] = friendId
		return rep
	}
	
	init?(friendUserName: String, friendAvatarStringURL: String, lastMessageContent: String, friendId: String) {
		self.friendUserName = friendUserName
		self.friendId = friendId
		self.lastMessageContent = lastMessageContent
		self.friendAvatarStringURL = friendAvatarStringURL
	}
	
	init?(document: QueryDocumentSnapshot){
		let data = document.data()
		guard let friendUserName = data["frientUserName"] as? String,
					let friendId = data["friendId"] as? String,
					let lastMessageContent = data["lastMessage"] as? String,
					let friendAvatarStringURL = data["friendAvatarStringURL"] as? String else { return nil }
		
		self.friendUserName = friendUserName
		self.friendId = friendId
		self.lastMessageContent = lastMessageContent
		self.friendAvatarStringURL = friendAvatarStringURL
	}
	
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(friendId)
	}

	static func == (lhs: MChat, rhs: MChat) -> Bool {
		return lhs.friendId == rhs.friendId
	}
}

