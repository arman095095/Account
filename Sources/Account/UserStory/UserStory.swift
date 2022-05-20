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
import AccountRouteMap
import ModelInterfaces
import SelectionRouteMap
import UserStoryFacade

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
        guard let accountProfile = safeResolver.resolve(AccountModelProtocol.self) else { fatalError(ErrorMessage.dependency.localizedDescription) }
        return accountModule(context: .edit(dto: accountProfile.profile))
    }
}

extension AccountUserStory: RouteMapPrivate {

    func regionSelectionModule() -> SelectionModule {
        let safeResolver = container.synchronize()
        guard let module = safeResolver.resolve(UserStoryFacadeProtocol.self)?.regionSelection?.countryAndCityModule() else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        return module
    }
    
    func accountModule(context: InputFlowContext) -> AccountModule {
        let safeResolver = container.synchronize()
        var profileManagerName: ProfileInfoManagersName
        switch context {
        case .edit:
            profileManagerName = .account
        case .create:
            profileManagerName = .auth
        }
        guard let alertManager = safeResolver.resolve(AlertManagerProtocol.self),
              let profileInfoManager = safeResolver.resolve(ProfileInfoManagerProtocol.self,
                                                            name: profileManagerName.rawValue) else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        let module = AccountAssembly.makeModule(alertManager: alertManager,
                                                profileInfoManager: profileInfoManager,
                                                context: context,
                                                routeMap: self)
        return module
    }
}

enum ErrorMessage: LocalizedError {
    case dependency
}
