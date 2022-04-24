//
//  AccountInteractor.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Managers
import Utils

protocol AccountInteractorInput: AnyObject {
    func createAccount(username: String,
                       info: String,
                       sex: String,
                       country: String,
                       city: String,
                       birthday: String,
                       userImage: UIImage)
    func editAccount(username: String,
                     info: String,
                     sex: String,
                     country: String,
                     city: String,
                     birthday: String,
                     userImage: UIImage)
    func validateProfile(username: String?,
                         info: String?,
                         sex: String?,
                         country: String?,
                         city: String?,
                         birthday: String?,
                         userImage: UIImage?)
}

protocol AccountInteractorOutput: AnyObject {
    func successCreatedProfile()
    func failedCreateProfile(message: String)
    func successEditedProfile()
    func failedEditProfile(message: String)
    func failedValidate(message: String)
    func successValidated(username: String,
                          info: String,
                          sex: String,
                          country: String,
                          city: String,
                          birthday: String,
                          userImage: UIImage)
}

final class AccountInteractor {
    
    weak var output: AccountInteractorOutput?
    private let authManager: AuthManagerProtocol
    private let validator: ProfileValidatorProtocol
    
    init(authManager: AuthManagerProtocol,
         validator: ProfileValidatorProtocol) {
        self.authManager = authManager
        self.validator = validator
    }
}

extension AccountInteractor: AccountInteractorInput {
    
    func validateProfile(username: String?,
                         info: String?,
                         sex: String?,
                         country: String?,
                         city: String?,
                         birthday: String?,
                         userImage: UIImage?) {
        guard let username = username,
              let info = info,
              let sex = sex,
              let country = country,
              let city = city,
              let birthday = birthday,
              let image = userImage else {
            output?.failedValidate(message: ProfileValidator.Error.notFilled.localizedDescription)
            return
        }
        
        guard validator.checkFilledInfo(username: username,
                                        info: info,
                                        sex: sex,
                                        birthday: birthday,
                                        country: country,
                                        city: city) else {
            output?.failedValidate(message: ProfileValidator.Error.notFilled.localizedDescription)
            return
        }
        guard validator.validateSelectedAge(with: birthday) else {
            output?.failedValidate(message: ProfileValidator.Error.ageNotValid.localizedDescription)
            return
        }
        guard validator.validateSelectedAgeNoLess16(date: birthday) else {
            output?.failedValidate(message: ProfileValidator.Error.ageLess16.localizedDescription)
            return
        }
        guard validator.validateSelectedImage(userImage: image) else {
            output?.failedValidate(message: ProfileValidator.Error.photoNotAdded.localizedDescription)
            return
        }
        output?.successValidated(username: username,
                                 info: info,
                                 sex: sex,
                                 country: country,
                                 city: city,
                                 birthday: birthday,
                                 userImage: image)
    }
    
    func createAccount(username: String,
                       info: String,
                       sex: String,
                       country: String,
                       city: String,
                       birthday: String,
                       userImage: UIImage) {
        guard let imageData = userImage.jpegData(compressionQuality: 0.4) else { return }
        authManager.createAccount(username: username,
                                  info: info,
                                  sex: sex,
                                  country: country,
                                  city: city,
                                  birthday: birthday,
                                  userImage: imageData) { [weak self] result in
            switch result {
            case .success:
                self?.output?.successCreatedProfile()
            case .failure(let error):
                self?.output?.failedCreateProfile(message: error.localizedDescription)
            }
        }
    }
    
    func editAccount(username: String,
                     info: String,
                     sex: String,
                     country: String,
                     city: String,
                     birthday: String,
                     userImage: UIImage) {
        guard let imageData = userImage.jpegData(compressionQuality: 0.4) else { return }
        authManager.editAccount(username: username,
                                info: info,
                                sex: sex,
                                country: country,
                                city: city,
                                birthday: birthday,
                                image: imageData,
                                imageURL: nil) { [weak self] result in
            switch result {
            case .success:
                self?.output?.successEditedProfile()
            case .failure(let error):
                self?.output?.failedEditProfile(message: error.localizedDescription)
            }
        }
    }
}
