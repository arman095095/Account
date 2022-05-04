//
//  File.swift
//  
//
//  Created by Арман Чархчян on 12.04.2022.
//

import Foundation
import AccountRouteMap

protocol RouteMapPrivate: AnyObject {
    func accountModule(context: InputFlowContext) -> AccountModule
}
