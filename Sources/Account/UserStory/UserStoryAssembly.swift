//
//  File.swift
//  
//
//  Created by Арман Чархчян on 22.04.2022.
//

import Foundation
import Swinject
import Utils
import Managers
import AccountRouteMap
import UserStoryFacade

public final class AccountUserStoryAssembly: Assembly {
    public init() { }
    public func assemble(container: Container) {
        AccountCacheServiceAssembly().assemble(container: container)
        AccountNetworkServiceAssembly().assemble(container: container)
        ProfileRemoteStorageServiceAssembly().assemble(container: container)
        ProfileCreateInfoManagerAssembly().assemble(container: container)
        ProfileEditInfoManagerAssembly().assemble(container: container)
        container.register(AccountRouteMap.self) { r in
            AccountUserStory(container: container)
        }
    }
}
