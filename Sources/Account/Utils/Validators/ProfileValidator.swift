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
