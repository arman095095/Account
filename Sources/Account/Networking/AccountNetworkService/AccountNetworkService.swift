//
//  AccountService.swift
//  
//
//  Created by Арман Чархчян on 10.04.2022.
//

import Foundation
import FirebaseFirestore
import ModelInterfaces
import UIKit
import NetworkServices

protocol AccountNetworkServiceProtocol {
    func createAccount(accountID: String,
                       profile: ProfileNetworkModelProtocol,
                       completion: @escaping (Result<Void, Error>) -> Void)
    func editAccount(accountID: String,
                     profile: ProfileNetworkModelProtocol,
                     completion: @escaping (Result<Void, Error>) -> Void)
}

final class AccountNetworkService {
    
    private let networkServiceRef: Firestore

    private var usersRef: CollectionReference {
        return networkServiceRef.collection(URLComponents.Paths.users.rawValue)
    }
    
    init(networkService: Firestore) {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        networkService.settings = settings
        self.networkServiceRef = networkService
    }
}

extension AccountNetworkService: AccountNetworkServiceProtocol {
    
    public func createAccount(accountID: String,
                              profile: ProfileNetworkModelProtocol,
                              completion: @escaping (Result<Void, Error>) -> Void) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            completion(.failure(ConnectionError.noInternet))
            return
        }
        self.setAccount(accountID: accountID, user: profile, completion: completion)
    }
    
    public func editAccount(accountID: String,
                            profile: ProfileNetworkModelProtocol,
                            completion: @escaping (Result<Void, Error>) -> Void) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            completion(.failure(ConnectionError.noInternet))
            return
        }
        setAccount(accountID: accountID, user: profile, completion: completion)
    }
}

private extension AccountNetworkService {
    
    func setAccount(accountID: String,
                    user: ProfileNetworkModelProtocol,
                    completion: @escaping (Result<Void,Error>) -> Void) {
        self.usersRef.document(accountID).setData(user.convertModelToDictionary()) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
}
