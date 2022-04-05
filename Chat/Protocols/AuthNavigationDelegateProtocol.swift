//
//  AuthNaviProtocol.swift
//  Chat
//
//  Created by Антон on 04.04.2022.
//

import Foundation


protocol AuthNavigationDelegateProtocol: class {
	func toLoginVC()
	func toSingUpVC()
}
