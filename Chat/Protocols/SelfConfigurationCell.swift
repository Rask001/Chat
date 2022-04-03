//
//  SelfConfigurationCell.swift
//  Chat
//
//  Created by Антон on 03.04.2022.
//

import Foundation

//MARK: - Protocol
protocol SelfConfigCellProtocol {
	static var reuseId: String { get }
	func configure(with value: MChat)
}
