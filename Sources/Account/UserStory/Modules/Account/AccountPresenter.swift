//
//  AccountPresenter.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import AlertManager
import SelectionRouteMap
import Utils
import AccountRouteMap
import SelectionRouteMap
import ModelInterfaces

public protocol AccountDateFormatProtocol {
    func getLocaleBirthdateText(date: Date) -> String
}

extension DateFormatService: AccountDateFormatProtocol { }

enum InputFlowContext {
    case edit(dto: ProfileModelProtocol)
    case create
    
    var managerName: String {
        switch self {
        case .edit:
            return "Account"
        case .create:
            return "Auth"
        }
    }
}

protocol AccountViewOutput: AnyObject {
    func viewDidLoad()
    func sendAccountInfo(userName: String?,
                         info: String?,
                         sex: String?,
                         userImage: UIImage?,
                         birthday: String?,
                         countryCity: String?)
    func countryCitySelection()
    func birthdateText(value: Date) -> String
}

final class AccountPresenter {
    
    weak var view: AccountViewInput?
    weak var output: AccountModuleOutput?
    private let stringFactory: AccountStringFactoryProtocol
    private let router: AccountRouterInput
    private let interactor: AccountInteractorInput
    private let context: InputFlowContext
    private let alertManager: AlertManagerProtocol
    private let dateFormatter: AccountDateFormatProtocol
    
    init(router: AccountRouterInput,
         interactor: AccountInteractorInput,
         context: InputFlowContext,
         alertManager: AlertManagerProtocol,
         stringFactory: AccountStringFactoryProtocol,
         dateFormatter: AccountDateFormatProtocol) {
        self.router = router
        self.interactor = interactor
        self.context = context
        self.alertManager = alertManager
        self.stringFactory = stringFactory
        self.dateFormatter = dateFormatter
    }
}

extension AccountPresenter: AccountViewOutput {
    
    func viewDidLoad() {
        switch context {
        case .edit(let info):
            view?.setupInitialStateForEdit(stringFactory: stringFactory)
            guard let profile = info as? AccountInfoViewModelProtocol else { return }
            view?.setupFilledFields(info: profile)
        case .create:
            view?.setupInitialStateForCreate(stringFactory: stringFactory)
        }
    }
    
    func countryCitySelection() {
        router.openRegionSelection(output: self)
    }
    
    func sendAccountInfo(userName: String?,
                         info: String?,
                         sex: String?,
                         userImage: UIImage?,
                         birthday: String?,
                         countryCity: String?) {
        view?.setLoading(on: true)
        interactor.validateProfile(username: userName,
                                   info: info,
                                   sex: sex,
                                   countryCity: countryCity,
                                   birthday: birthday,
                                   userImage: userImage)
    }
    
    func birthdateText(value: Date) -> String {
        dateFormatter.getLocaleBirthdateText(date: value)
    }
}

extension AccountPresenter: SelectionModuleOutput {
    func selectionCompleted(items: [String]) {
        guard items.count == 2 else { return }
        let info = "\(items[0]), \(items[1])"
        view?.setupRegion(info: info)
        router.dismissRegionSelection()
    }
}

extension AccountPresenter: AccountInteractorOutput {
    func successSendedProfile(accountModel: AccountModelProtocol) {
        view?.setLoading(on: false)
        switch context {
        case .edit:
            alertManager.present(type: .success, title: stringFactory.successEditedMessage)
            router.dismissModule()
        case .create:
            alertManager.present(type: .success, title: stringFactory.successCreatedMessage)
            output?.userSuccessAuthorized(account: accountModel)
        }
    }
    
    func failureSendProfile(message: String) {
        view?.setLoading(on: false)
        alertManager.present(type: .error, title: message)
    }
    
    func successValidated(username: String,
                          info: String,
                          sex: String,
                          country: String,
                          city: String,
                          birthday: String,
                          userImage: UIImage) {
        interactor.sendAccount(username: username,
                               info: info,
                               sex: sex,
                               country: country,
                               city: city,
                               birthday: birthday,
                               userImage: userImage)
    }
}

extension AccountPresenter: AccountModuleInput {
    
}
