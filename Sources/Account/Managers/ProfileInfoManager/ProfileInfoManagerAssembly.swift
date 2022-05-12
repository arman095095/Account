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

public enum ProfileInfoManagersName: String {
    case auth
    case account
}

public final class ProfileInfoManagerAssembly: Assembly {
    public func assemble(container: Container) {
        
        container.register(ProfileInfoManagerProtocol.self,
                           name: ProfileInfoManagersName.auth.rawValue) { r in
            guard let accountID = r.resolve(String.self, name: "accountID"),
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
