//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import Foundation
import Utils

public protocol ProfileValidatorProtocol {
    func validateSelectedAgeNoLess16(date: String) -> Bool
    func validateSelectedAge(with date: String) -> Bool
    func checkFilledInfo(username: String,
                         info: String,
                         sex: String,
                         birthday: String,
                         country: String,
                         city: String) -> Bool
}

struct ProfileValidator: ProfileValidatorProtocol {
    
    enum Error: LocalizedError {
        case notFilled
        case photoNotAdded
        case ageLess16
        case ageNotValid
        
        public var errorDescription: String? {
            switch self {
            case .notFilled:
                return NSLocalizedString("Заполните все поля", comment: "")
            case .photoNotAdded:
                return NSLocalizedString("Вы не добавили фото", comment: "")
            case .ageLess16:
                return NSLocalizedString("Вам нет 16-ти лет", comment: "")
            case .ageNotValid:
                return NSLocalizedString("Пожалуйста, введите корректную дату рождения", comment: "")
            }
        }
    }
    
    public func validateSelectedAgeNoLess16(date: String) -> Bool {
        guard let age = Int(DateFormatService().getAge(date: date)) else { return false }
        return !(age < 16)
    }
    
    public func validateSelectedAge(with date: String) -> Bool {
        guard let age = Int(DateFormatService().getAge(date: date)) else { return false }
        return !(age > 120 || age < 1)
    }
    
    public func checkFilledInfo(username: String,
                                info: String,
                                sex: String,
                                birthday: String,
                                country: String,
                                city: String) -> Bool {
        return !(username == "" || info == "" || sex == "" || birthday == "" || country == "" || city == "")
    }
}
