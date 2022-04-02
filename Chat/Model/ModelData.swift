//
//  ModelData.swift
//  Chat
//
//  Created by Антон on 02.04.2022.
//
import UIKit

struct MChat: Hashable, Decodable {
	var username: String
	var userImageString: String
	var lastMessage: String?
	var id: Int

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}

	static func == (lhs: MChat, rhs: MChat) -> Bool {
		return lhs.id == rhs.id
	}
}


func reedJson(name: String) -> [MChat]{
	guard let sourcesUrl = Bundle.main.url(forResource: name, withExtension: "json") else {
	fatalError("Could not finde \(name).json...")
	
}
guard let modelData = try? Data(contentsOf: sourcesUrl) else {
		fatalError("Could not conver data...")
}
let decoder = JSONDecoder()
guard let activeChats = try? decoder.decode([MChat].self, from: modelData) else {
	fatalError("There was a problem decoding Data..")
}
	return activeChats
}
