//
//  File 3.swift
//  
//
//  Created by Арман Чархчян on 26.05.2022.
//

import Foundation
import Swinject
import NetworkServices
import ModelInterfaces
import Managers
import Services

final class ProfileEditInfoManagerAssembly: Assembly {

    func assemble(container: Container) {
        
        container.register(ProfileInfoManagerProtocol.self, name: ProfileInfoManagersName.account.rawValue) { r in
            guard let account = r.resolve(AccountModelProtocol.self),
                  let remoteStorageService = r.resolve(ProfileRemoteStorageServiceProtocol.self),
                  let accountService = r.resolve(AccountNetworkServiceProtocol.self),
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
