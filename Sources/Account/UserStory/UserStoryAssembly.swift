//
//  File.swift
//  
//
//  Created by Арман Чархчян on 22.04.2022.
//

import Foundation
import Swinject
import Utils

public final class AccountUserStoryAssembly {
    public static func assemble(container: Container) {
        container.register(ProfileValidatorProtocol.self) { r in
            ProfileValidator()
        }
    }
}
