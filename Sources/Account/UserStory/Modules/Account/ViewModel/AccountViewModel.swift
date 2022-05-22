//
//  File.swift
//  
//
//  Created by Арман Чархчян on 14.04.2022.
//

import UIKit
import Utils
import ModelInterfaces

protocol AccountInfoViewModelProtocol {
    var displayName: String { get }
    var info: String { get }
    var countryCity: String { get }
    var birthday: String { get }
    var birthdayDate: Date { get }
    var sexIndex: Int { get }
    var photoURL: URL? { get }
}

final class AccountInfoViewModel: AccountInfoViewModelProtocol {
    
    enum Sex: String {
        case male = "Мужчина"
        case female = "Женщина"
        
        var index: Int {
            switch self {
            case .male:
                return 0
            case .female:
                return 1
            }
        }
    }

    var displayName: String
    var info: String
    var countryCity: String
    var birthday: String
    var birthdayDate: Date
    var sexIndex: Int
    var photoURL: URL?
    
    init(profile: ProfileModelProtocol) {
        self.displayName = profile.userName
        self.countryCity = "\(profile.country), \(profile.city)"
        self.birthdayDate = DateFormatService().getBirthdate(from: profile.birthday)
        self.sexIndex = Sex(rawValue: profile.sex)?.index ?? 0
        self.photoURL = URL(string: profile.imageUrl)
        self.birthday = profile.birthday
        self.info = profile.info
    }
}
