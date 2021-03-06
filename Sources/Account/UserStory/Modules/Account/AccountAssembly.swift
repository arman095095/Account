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
import AccountRouteMap

enum AccountAssembly {
    static func makeModule(alertManager: AlertManagerProtocol,
                           profileInfoManager: ProfileInfoManagerProtocol,
                           context: InputFlowContext,
                           routeMap: RouteMapPrivate) -> AccountModule {
        let view = AccountViewController()
        let router = AccountRouter(routeMap: routeMap)
        let profileValidator = ProfileValidator()
        let interactor = AccountInteractor(profileInfoManager: profileInfoManager,
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
