//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import Foundation
import Swinject
import FirebaseFirestore

final class AccountNetworkServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AccountNetworkServiceProtocol.self) { r in
            AccountNetworkService(networkService: Firestore.firestore())
        }
    }
}
