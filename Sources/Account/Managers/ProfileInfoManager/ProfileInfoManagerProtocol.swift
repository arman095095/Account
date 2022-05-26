//
//  File 2.swift
//  
//
//  Created by Арман Чархчян on 26.05.2022.
//

import Foundation
import ModelInterfaces

enum ProfileInfoManagersName: String {
    case auth
    case account
}

protocol ProfileInfoManagerProtocol: AnyObject {
    func sendProfile(username: String,
                     info: String,
                     sex: String,
                     country: String,
                     city: String,
                     birthday: String,
                     image: Data?,
                     completion: @escaping (Result<AccountModelProtocol, Error>) -> Void)
}
