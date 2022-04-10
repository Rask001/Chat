//
//  ModelData.swift
//  Chat
//
//  Created by Антон on 02.04.2022.
//
import Foundation

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
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(friendId)
	}

	static func == (lhs: MChat, rhs: MChat) -> Bool {
		return lhs.friendId == rhs.friendId
	}
}

