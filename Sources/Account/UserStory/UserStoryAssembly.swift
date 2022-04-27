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

enum ProfileInfoManagersName: String {
    case create
    case edit
    
    init(context: InputFlowContext) {
        switch context {
        case .edit(_):
            self = .edit
        case .create:
            self = .create
        }
    }
}

public final class AccountUserStoryAssembly {
    public static func assemble(container: Container) {
        container.register(ProfileInfoManagerProtocol.self,
                           name: ProfileInfoManagersName.create.rawValue) { r in
            guard let profileInfoManager = r.resolve(AuthManagerProtocol.self) else { fatalError(ErrorMessage.dependency.localizedDescription)
            }
            return profileInfoManager
        }
        container.register(ProfileInfoManagerProtocol.self,
                           name: ProfileInfoManagersName.edit.rawValue) { r in
            guard let profileInfoManager = r.resolve(AccountManagerProtocol.self) else { fatalError(ErrorMessage.dependency.localizedDescription)
            }
            return profileInfoManager
        }
        container.register(ProfileValidatorProtocol.self) { r in
            ProfileValidator()
        }
    }
}
