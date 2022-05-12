//
//  File.swift
//  
//
//  Created by Арман Чархчян on 12.05.2022.
//

import Foundation
import Swinject
import NetworkServices
import ModelInterfaces
import Managers
import Services

enum ProfileInfoManagersName: String {
    case auth
    case account
}

final class ProfileInfoManagerAssembly: Assembly {

    enum Names: String {
        case accountID
    }

    func assemble(container: Container) {
        
        container.register(ProfileInfoManagerProtocol.self,
                           name: ProfileInfoManagersName.auth.rawValue) { r in
            guard let accountID = r.resolve(String.self, name: Names.accountID.rawValue),
                  let remoteStorageService = r.resolve(RemoteStorageServiceProtocol.self),
                  let accountService = r.resolve(AccountServiceProtocol.self),
                  let quickAccessManager = r.resolve(QuickAccessManagerProtocol.self) else {
                fatalError(ErrorMessage.dependency.localizedDescription)
            }
            return ProfileInfoCreateManager(accountID: accountID,
                                     remoteStorageService: remoteStorageService,
                                     accountService: accountService,
                                     quickAccessManager: quickAccessManager)
        }
        
        container.register(ProfileInfoManagerProtocol.self, name: ProfileInfoManagersName.account.rawValue) { r in
            guard let account = r.resolve(AccountModelProtocol.self),
                  let remoteStorageService = r.resolve(RemoteStorageServiceProtocol.self),
                  let accountService = r.resolve(AccountServiceProtocol.self),
                  let accountID = r.resolve(QuickAccessManagerProtocol.self)?.userID,
                  let cacheService = r.resolve(AccountCacheServiceProtocol.self) else {
                fatalError(ErrorMessage.dependency.localizedDescription)
            }
            return ProfileInfoEditManager(accountID: accountID,
                                          account: account,
                                          remoteStorageService: remoteStorageService,
                                          accountService: accountService,
                                          cacheService: cacheService)
        }
    }
}
