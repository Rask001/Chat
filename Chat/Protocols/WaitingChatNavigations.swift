//
//  WaitingChatNavigations.swift
//  Chat
//
//  Created by Антон on 11.04.2022.
//

import Foundation

protocol WaitingChatNavigationsProtocol: Any {
	func removeWaitingChat(chat: MChat)
	func changeToActive(chat: MChat)
}
