//
//  Users.swift
//  Chat
//
//  Created by Антон on 03.04.2022.
//

import Foundation

struct MUser: Hashable, Decodable {
	var username: String
	var avatarStringURL: String
	var id: Int

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
