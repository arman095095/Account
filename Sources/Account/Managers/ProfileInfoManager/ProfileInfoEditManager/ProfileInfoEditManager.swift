//
//  File.swift
//  
//
//  Created by Арман Чархчян on 26.05.2022.
//

import Foundation
import ModelInterfaces

final class ProfileInfoEditManager {
    private let accountID: String
    private let account: AccountModelProtocol
    private let remoteStorageService: ProfileRemoteStorageServiceProtocol
    private let accountService: AccountNetworkServiceProtocol
    private let cacheService: AccountCacheServiceProtocol
    
    init(accountID: String,
         account: AccountModelProtocol,
         remoteStorageService: ProfileRemoteStorageServiceProtocol,
         accountService: AccountNetworkServiceProtocol,
         cacheService: AccountCacheServiceProtocol) {
        self.accountID = accountID
        self.account = account
        self.remoteStorageService = remoteStorageService
        self.accountService = accountService
        self.cacheService = cacheService
    }
}

extension ProfileInfoEditManager: ProfileInfoManagerProtocol {
    func sendProfile(username: String,
                     info: String,
                     sex: String,
                     country: String,
                     city: String,
                     birthday: String,
                     image: Data?,
                     completion: @escaping (Result<AccountModelProtocol, Error>) -> Void) {
        guard let image = image else {
            let imageURL = account.profile.imageUrl
            let edited = ProfileNetworkModel(userName: username,
                                             imageName: imageURL,
                                             identifier: self.accountID,
                                             sex: sex,
                                             info: info,
                                             birthDay: birthday,
                                             country: country,
                                             city: city)
            set(edited: edited, completion: completion)
            return
        }
        remoteStorageService.uploadProfile(accountID: accountID, image: image) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let url):
                let edited = ProfileNetworkModel(userName: username,
                                                 imageName: url.absoluteString,
                                                 identifier: self.accountID,
                                                 sex: sex,
                                                 info: info,
                                                 birthDay: birthday,
                                                 country: country,
                                                 city: city)
                self.set(edited: edited, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension ProfileInfoEditManager {
    func set(edited: ProfileNetworkModelProtocol,
             completion: @escaping (Result<AccountModelProtocol, Error>) -> Void) {
        accountService.setAccountInfo(accountID: self.accountID,
                                   profile: edited) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                let model = ProfileModel(profile: edited)
                self.account.profile = model
                self.cacheService.store(accountModel: self.account)
                completion(.success((self.account)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
