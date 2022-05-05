//
//  File.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//

import Foundation
import AccountRouteMap
import SelectionRouteMap

protocol RouteMapPrivate: AnyObject {
    func accountModule(context: InputFlowContext) -> AccountModule
    func regionSelectionModule() -> SelectionModule
}
