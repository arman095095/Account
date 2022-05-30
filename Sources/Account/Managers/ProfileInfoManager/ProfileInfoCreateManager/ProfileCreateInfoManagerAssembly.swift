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

final class ProfileCreateInfoManagerAssembly: Assembly {

    func assemble(container: Container) {
        container.register(ProfileInfoManagerProtocol.self,
                           name: ProfileInfoManagersName.auth.rawValue) { r in
            guard let accountID = r.resolve(String.self, name: Names.accountID.rawValue),
                  let remoteStorageService = r.resolve(ProfileRemoteStorageServiceProtocol.self),
                  let accountService = r.resolve(AccountNetworkServiceProtocol.self),
                  let quickAccessManager = r.resolve(QuickAccessManagerProtocol.self) else {
                fatalError(ErrorMessage.dependency.localizedDescription)
            }
            return ProfileInfoCreateManager(accountID: accountID,
                                     remoteStorageService: remoteStorageService,
                                     accountService: accountService,
                                     quickAccessManager: quickAccessManager)
        }
    }
}
