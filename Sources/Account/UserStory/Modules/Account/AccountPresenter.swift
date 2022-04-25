//
//  AccountPresenter.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import AlertManager
import Selection
import Managers
import Utils

public protocol AccountDateFormatProtocol {
    func getLocaleBirthdateText(date: Date) -> String
}

extension DateFormatService: AccountDateFormatProtocol { }

public protocol AccountModuleOutput: AnyObject {
    func accountModuleFinished()
}

public protocol AccountModuleInput: AnyObject {
    
}

enum InputFlowContext {
    case edit(dto: ProfileModelProtocol)
    case create
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
        guard let countryCityComponents = countryCity?.components(separatedBy: ", "),
              countryCityComponents.count == 2 else { return }
        view?.setLoading(on: true)
        interactor.validateProfile(username: userName,
                                   info: info,
                                   sex: sex,
                                   country: countryCityComponents[0],
                                   city: countryCityComponents[1],
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
    func successEditedProfile() {
        view?.setLoading(on: false)
        alertManager.present(type: .success, title: stringFactory.successEditedMessage)
        router.dismissModule()
    }
    
    func failedEditProfile(message: String) {
        view?.setLoading(on: false)
        alertManager.present(type: .error, title: message)
    }
    
    func successCreatedProfile() {
        view?.setLoading(on: false)
        alertManager.present(type: .success, title: stringFactory.successCreatedMessage)
        output?.userAuthorized()
    }
    
    func failedCreateProfile(message: String) {
        view?.setLoading(on: false)
        alertManager.present(type: .error, title: message)
    }
    
    func failedValidate(message: String) {
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
        switch context {
        case .edit:
            interactor.editAccount(username: username,
                                   info: info,
                                   sex: sex,
                                   country: country,
                                   city: city,
                                   birthday: birthday,
                                   userImage: userImage)
        case .create:
            interactor.createAccount(username: username,
                                     info: info,
                                     sex: sex,
                                     country: country,
                                     city: city,
                                     birthday: birthday,
                                     userImage: userImage)
        }
    }
}

extension AccountPresenter: AccountModuleInput {
    
}
