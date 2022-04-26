//
//  AuthorizationUserStory.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//

import Foundation
import Module
import Managers
import Swinject
import AlertManager
import Utils

public protocol AccountRouteMap: AnyObject {
    func createAccountModule() -> AccountModule
    func editAccountModule() -> AccountModule
}

public final class AccountUserStory {
    private let container: Container
    public init(container: Container) {
        self.container = container
    }
}

extension AccountUserStory: AccountRouteMap {
    public func createAccountModule() -> AccountModule {
        return accountModule(context: .create)
    }
    
    public func editAccountModule() -> AccountModule {
        let safeResolver = container.synchronize()
        guard let accountManager = safeResolver.resolve(AccountManagerProtocol.self),
              let accountProfile = accountManager.account?.profile else { fatalError(ErrorMessage.dependency.localizedDescription) }
        return accountModule(context: .edit(dto: accountProfile))
    }
}

extension AccountUserStory: RouteMapPrivate {
    func accountModule(context: InputFlowContext) -> AccountModule {
        let safeResolver = container.synchronize()
        guard let alertManager = safeResolver.resolve(AlertManagerProtocol.self),
              let profileInfoManager = safeResolver.resolve(ProfileInfoManagerProtocol.self,
                                                            name: context.managerName),
              let profileValidator = safeResolver.resolve(ProfileValidatorProtocol.self) else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        let module = AccountAssembly.makeModule(alertManager: alertManager,
                                                profileInfoManager: profileInfoManager,
                                                profileValidator: profileValidator,
                                                context: context)
        return module
    }
}

enum ErrorMessage: LocalizedError {
    case dependency
}
