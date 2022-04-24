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
    func createAccountModule() -> ModuleProtocol
    func editAccountModule() -> ModuleProtocol
}

public final class AccountUserStory {
    private let container: Container
    public init(container: Container) {
        self.container = container
    }
}

extension AccountUserStory: AccountRouteMap {
    public func createAccountModule() -> ModuleProtocol {
        return accountModule(context: .create)
    }
    
    public func editAccountModule() -> ModuleProtocol {
        let safeResolver = container.synchronize()
        guard let authManager = safeResolver.resolve(AuthManagerProtocol.self),
              let accountProfile = authManager.currentAccount?.profile else { fatalError(ErrorMessage.dependency.localizedDescription) }
        return accountModule(context: .edit(dto: accountProfile))
    }
}

extension AccountUserStory: RouteMapPrivate {
    func accountModule(context: InputFlowContext) -> AccountModule {
        let safeResolver = container.synchronize()
        guard let alertManager = safeResolver.resolve(AlertManagerProtocol.self),
              let authManager = safeResolver.resolve(AuthManagerProtocol.self),
              let profileValidator = safeResolver.resolve(ProfileValidatorProtocol.self) else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
              
        let module = AccountAssembly.makeModule(alertManager: alertManager,
                                                authManager: authManager,
                                                profileValidator: profileValidator,
                                                context: context)
        return module
    }
}

enum ErrorMessage: LocalizedError {
    case dependency
}
