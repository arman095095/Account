//
//  File.swift
//  
//
//  Created by Арман Чархчян on 13.04.2022.
//

import Foundation

protocol AccountStringFactoryProtocol {
    var successCreatedMessage: String { get }
    var successEditedMessage: String { get }
    var editTitle: String { get }
    var createTitle: String { get }
    var subtitle: String { get }
    var createButtonTitle: String { get }
    var editButtonTitle: String { get }
    var imageDefaultName: String { get }
    var buttonImageDefaultName: String { get }
    var nameTitleText: String { get }
    var infoTitleText: String { get }
    var birthdayTitleText: String { get }
    var regionTitleText: String { get }
    var maleTitleText: String { get }
    var femaleTitleText: String { get }
    var sexTitleText: String { get }
}

struct AccountStringFactory: AccountStringFactoryProtocol {
    var imageDefaultName: String = "people"
    var buttonImageDefaultName: String = "add"
    var nameTitleText: String = "Имя (видно всем)"
    var infoTitleText: String = "Информация о Вас"
    var birthdayTitleText: String = "Дата рождения"
    var regionTitleText: String = "Страна, Город"
    var maleTitleText: String = "Мужчина"
    var femaleTitleText: String = "Женщина"
    var sexTitleText: String = "Пол"
    var successCreatedMessage: String = "Профиль успешно создан"
    var successEditedMessage: String = "Данные успешно отредактированы"
    var editTitle: String = "Редактирование профиля"
    var createTitle: String = "Создание профиля"
    var subtitle: String = "Данные профиля"
    var createButtonTitle: String = "Создать аккаунт"
    var editButtonTitle: String = "Сохранить"
}
