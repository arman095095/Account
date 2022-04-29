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
    func sendAccount(username: String,
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
    
    func successSendedProfile(accountModel: AccountModelProtocol)
    func failureSendProfile(message: String)
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
    private let profileInfoManager: ProfileInfoManagerProtocol
    private let validator: ProfileValidatorProtocol
    
    init(profileInfoManager: ProfileInfoManagerProtocol,
         validator: ProfileValidatorProtocol) {
        self.profileInfoManager = profileInfoManager
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
            output?.failureSendProfile(message: ValidationError.Profile.notFilled.localizedDescription)
            return
        }
        
        guard validator.checkFilledInfo(username: username,
                                        info: info,
                                        sex: sex,
                                        birthday: birthday,
                                        country: country,
                                        city: city) else {
            output?.failureSendProfile(message: ValidationError.Profile.notFilled.localizedDescription)
            return
        }
        guard validator.validateSelectedAge(with: birthday) else {
            output?.failureSendProfile(message: ValidationError.Profile.ageNotValid.localizedDescription)
            return
        }
        guard validator.validateSelectedAgeNoLess16(date: birthday) else {
            output?.failureSendProfile(message: ValidationError.Profile.ageLess16.localizedDescription)
            return
        }
        guard validator.validateSelectedImage(userImage: image) else {
            output?.failureSendProfile(message: ValidationError.Profile.photoNotAdded.localizedDescription)
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
    
    func sendAccount(username: String,
                     info: String,
                     sex: String,
                     country: String,
                     city: String,
                     birthday: String,
                     userImage: UIImage) {
        guard let imageData = userImage.jpegData(compressionQuality: 0.4) else { return }
        profileInfoManager.sendProfile(username: username,
                                       info: info,
                                       sex: sex,
                                       country: country,
                                       city: city,
                                       birthday: birthday,
                                       image: imageData) { [weak self] result in
            switch result {
            case .success(let account):
                self?.output?.successSendedProfile(accountModel: account)
            case .failure(let error):
                self?.output?.failureSendProfile(message: error.localizedDescription)
            }
        }
    }
}
