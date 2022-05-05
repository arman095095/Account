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
        container.register(AccountRouteMap.self) { r in
            AccountUserStory(container: container)
        }
    }
}
