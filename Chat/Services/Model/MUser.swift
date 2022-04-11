//
//  Users.swift
//  Chat
//
//  Created by Антон on 03.04.2022.
//

import Foundation
import Firebase

struct MUser: Hashable, Decodable {
	var username: String
	var email: String
	var avatarStringURL: String
	var description: String
	var sex: String
	var id: String
	
	init(username: String, email: String, avatarStringURL: String, description: String, sex: String, id: String) {
		self.username = username
		self.id = id
		self.email = email
		self.avatarStringURL = avatarStringURL
		self.sex = sex
		self.description = description
	}
	
	init?(document: DocumentSnapshot) {
		guard let data = document.data() else { return nil }
		guard let username = data["username"] as? String,
					let id = data["uid"] as? String,
					let email = data["email"] as? String,
					let avatarStringURL = data["avatarStringURL"] as? String,
					let sex = data["sex"] as? String,
					let description = data["description"] as? String else { return nil }
		
		self.username = username
		self.id = id
		self.email = email
		self.avatarStringURL = avatarStringURL
		self.sex = sex
		self.description = description
	}
	
	init?(document: QueryDocumentSnapshot) {
		      let data = document.data()
		guard let username = data["username"] as? String,
					let id = data["uid"] as? String,
					let email = data["email"] as? String,
					let avatarStringURL = data["avatarStringURL"] as? String,
					let sex = data["sex"] as? String,
					let description = data["description"] as? String else { return nil }
		
		self.username = username
		self.id = id
		self.email = email
		self.avatarStringURL = avatarStringURL
		self.sex = sex
		self.description = description
	}

	var representation: [String : Any] {
		var rep = ["username" : username]
		rep["sex"] = sex
		rep["email"] = email
		rep["avatarStringURL"] = avatarStringURL
		rep["description"] = description
		rep["uid"] = id
		return rep
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}

	static func == (lhs: MUser, rhs: MUser) -> Bool {
		return lhs.id == rhs.id
	}
	
	func contains(filter: String?) -> Bool{ //функция для поиска юзеров в массиве
		guard let filter = filter else { return true }
		if filter.isEmpty { return true }
		let lowercasedFilter = filter.lowercased()
		return username.lowercased().contains(lowercasedFilter)
	}
}
