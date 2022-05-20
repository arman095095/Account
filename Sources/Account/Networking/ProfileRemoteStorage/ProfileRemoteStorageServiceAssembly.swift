//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import Foundation
import Swinject
import FirebaseStorage

final class ProfileRemoteStorageServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ProfileRemoteStorageServiceProtocol.self) { r in
            ProfileRemoteStorageService(storage: Storage.storage())
        }
    }
}
