//
//  ReadJson.swift
//  Chat
//
//  Created by Антон on 03.04.2022.
//

import Foundation

func reedJsonMChat(name: String) -> [MChat]{
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

func reedJsonMUser(name: String) -> [MUser]{
	guard let sourcesUrl = Bundle.main.url(forResource: name, withExtension: "json") else {
		fatalError("Could not finde \(name).json...")
	}
	
	guard let modelData = try? Data(contentsOf: sourcesUrl) else {
		fatalError("Could not conver data...")
	}
	
	let decoder = JSONDecoder()
	guard let activeChats = try? decoder.decode([MUser].self, from: modelData) else {
		fatalError("There was a problem decoding Data..")
	}
	
	return activeChats
}
