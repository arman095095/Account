//
//  AccountAssembly.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Module
import Managers
import Utils
import AlertManager
import Swinject

typealias AccountModule = Module<AccountModuleInput, AccountModuleOutput>

enum AccountAssembly {
    static func makeModule(alertManager: AlertManagerProtocol,
                           authManager: AuthManagerProtocol,
                           profileValidator: ProfileValidatorProtocol,
                           context: InputFlowContext) -> AccountModule {
        let view = AccountViewController()
        let router = AccountRouter()
        let interactor = AccountInteractor(authManager: authManager,
                                           validator: profileValidator)
        let stringFactory = AccountStringFactory()
        let dateFormatter = DateFormatService()
        let presenter = AccountPresenter(router: router,
                                         interactor: interactor,
                                         context: context,
                                         alertManager: alertManager,
                                         stringFactory: stringFactory,
                                         dateFormatter: dateFormatter)
        view.output = presenter
        interactor.output = presenter
        presenter.view = view
        router.transitionHandler = view
        return AccountModule(input: presenter, view: view) {
            presenter.output = $0
        }
    }
}
