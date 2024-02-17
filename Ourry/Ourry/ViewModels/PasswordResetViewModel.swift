//
//  PasswordResetViewModel.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2/17/24.
//

import Foundation
import Alamofire

class PasswordResetViewModel {
    
    private let passwordResetManager: PasswordResetManager
    
    init(passwordResetManager: PasswordResetManager) {
        self.passwordResetManager = passwordResetManager
    }
    
    func resetPassword(email: String, newPassword: String, confirmPassword: String, completion: @escaping (Result<String, AuthError>) -> Void) {
        
        passwordResetManager.resetPassword(email: email, newPassword: newPassword, confirmPassword: confirmPassword ){ result in
            switch result {
            case .success(let message):
                completion(.success(message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
