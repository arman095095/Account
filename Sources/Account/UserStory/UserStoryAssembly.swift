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

public final class AccountUserStoryAssembly: Assembly {
    public init() { }
    public func assemble(container: Container) {
        
    }
}
