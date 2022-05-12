//
//  File.swift
//  
//
//  Created by Арман Чархчян on 14.04.2022.
//

import UIKit
import Services
import Utils

public protocol AccountInfoViewModelProtocol {
    var displayName: String { get }
    var info: String { get }
    var countryCity: String { get }
    var birthday: String { get }
    var birthdayDate: Date { get }
    var sexIndex: Int { get }
    var photoURL: URL? { get }
}

extension ProfileModel: AccountInfoViewModelProtocol {
    
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
    
    public var displayName: String {
        self.userName
    }
    
    public var countryCity: String {
        "\(self.country), \(self.city)"
    }
    
    public var birthdayDate: Date {
        DateFormatService().getBirthdate(from: birthday)
    }
    
    public var sexIndex: Int {
        Sex(rawValue: self.sex)?.index ?? 0
    }
    
    public var photoURL: URL? {
        URL(string: self.imageUrl)
    }
}
