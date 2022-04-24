//
//  AccountRouter.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Selection
import Module

protocol AccountRouterInput: AnyObject {
    func openRegionSelection(output: SelectionModuleOutput)
    func dismissRegionSelection()
    func dismissModule()
}

final class AccountRouter {
    weak var transitionHandler: UIViewController?
}

extension AccountRouter: AccountRouterInput {

    func dismissModule() {
        transitionHandler?.navigationController?.popViewController(animated: true)
    }
    
    func dismissRegionSelection() {
        guard let transitionHandler = transitionHandler else { return }
        transitionHandler.navigationController?.popToViewController(transitionHandler, animated: true)
    }
    
    func openRegionSelection(output: SelectionModuleOutput) {
        let module = RegionUserStory().countryAndCityModule()
        module.output = output
        self.push(module)
    }
}

private extension AccountRouter {
    func push(_ module: ModuleProtocol) {
        let transition = PushTransition()
        transition.destination = module.view
        transition.source = transitionHandler
        transition.perform(nil)
    }
}
