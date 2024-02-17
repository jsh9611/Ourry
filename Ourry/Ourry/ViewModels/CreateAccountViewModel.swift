//
//  CreateAccountViewModel.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2/17/24.
//

import Foundation
import Alamofire

class CreateAccountViewModel {
    
    private let createAccountManager: CreateAccountManager
    
    init(createAccountManager: CreateAccountManager) {
        self.createAccountManager = createAccountManager
    }
    
    func registration(email: String, password: String, nickname: String, phone: String, completion: @escaping (Result<String, AuthError>) -> Void) {
        createAccountManager.registration(email: email, password: password, nickname: nickname, phone: phone) { result in
            switch result {
            case .success(let message):
                completion(.success(message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
