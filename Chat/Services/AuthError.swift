//
//  AuthError.swift
//  Chat
//
//  Created by Антон on 04.04.2022.
//

import Foundation

enum AuthError {
	case notFilled
	case invalidEmail
	case passwordNotMatched
	case serverError
	case unknowError
}

extension AuthError: LocalizedError {
	var errorDescription: String? {
		switch self {
			
		case .notFilled:
			return NSLocalizedString("Заполните все поля", comment: "")
		case .invalidEmail:
			return NSLocalizedString("формат почты не верен", comment: "")
		case .passwordNotMatched:
			return NSLocalizedString("Пароли не совпадают", comment: "")
		case .serverError:
			return NSLocalizedString("Ошибка сервера", comment: "")
		case .unknowError:
			return NSLocalizedString("Неведомая ошибка", comment: "")
		}
	}
}
