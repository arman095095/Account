//
//  File.swift
//  
//
//  Created by Арман Чархчян on 12.05.2022.
//

import Foundation
import ModelInterfaces
import NetworkServices
import Services
import Managers

final class ProfileInfoCreateManager {
    private let accountID: String
    private let remoteStorageService: ProfileRemoteStorageServiceProtocol
    private let accountService: AccountNetworkServiceProtocol
    private let quickAccessManager: QuickAccessManagerProtocol
    
    init(accountID: String,
         remoteStorageService: ProfileRemoteStorageServiceProtocol,
         accountService: AccountNetworkServiceProtocol,
         quickAccessManager: QuickAccessManagerProtocol) {
        self.accountID = accountID
        self.remoteStorageService = remoteStorageService
        self.accountService = accountService
        self.quickAccessManager = quickAccessManager
    }
}

extension ProfileInfoCreateManager: ProfileInfoManagerProtocol {
    func sendProfile(username: String,
                     info: String,
                     sex: String,
                     country: String,
                     city: String,
                     birthday: String,
                     image: Data?,
                     completion: @escaping (Result<AccountModelProtocol, Error>) -> Void) {
        guard let image = image else { return }
        remoteStorageService.uploadProfile(accountID: accountID, image: image) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let url):
                let profileModel = ProfileNetworkModel(userName: username,
                                                       imageName: url.absoluteString,
                                                       identifier: self.accountID,
                                                       sex: sex,
                                                       info: info,
                                                       birthDay: birthday,
                                                       country: country,
                                                       city: city)
                self.accountService.setAccountInfo(accountID: self.accountID,
                                                  profile: profileModel) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success:
                        let profile = ProfileModel(profile: profileModel)
                        let account = AccountModel(profile: profile,
                                                   blockedIDs: [],
                                                   friendIds: [],
                                                   waitingsIds: [],
                                                   requestIds: [])
                        self.quickAccessManager.userID = self.accountID
                        completion(.success((account)))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
