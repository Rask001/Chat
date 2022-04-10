//
//  UserError.swift
//  Chat
//
//  Created by Антон on 05.04.2022.
//

import Foundation

//MARK: - различные ошибки связанные с пользователем

enum UserError {
	case notFilled
	case photoNotExist
	case userNotExist
	case cannotUnwrapToMUser
	
}


extension UserError: LocalizedError {
	var errorDescription: String? {
		switch self {
			
		case .notFilled:
			return NSLocalizedString("Заполните все поля", comment: "")
		case .photoNotExist:
			return NSLocalizedString("Пользователь не выбрал фотографию", comment: "")
		case .userNotExist:
			return NSLocalizedString("Невозможно загрузить информацию о User из Firebase", comment: "")
		case .cannotUnwrapToMUser:
			return NSLocalizedString("Невозможно конвертировать MUser из User", comment: "")
		}
	}
}
