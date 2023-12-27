//
//  LoginManager.swift
//  Ourry
//
//  Created by SeongHoon Jang on 12/16/23.
//

import Foundation
import Alamofire

enum LoginResult {
    case success(jwtToken: String)
    case failure(error: AuthError)
}

class LoginManager {
    
    static let shared = LoginManager()
    
    func login(email: String, password: String, completion: @escaping (Result<String, AuthError>) -> Void) {
        let urlString = "http://localhost:8080/member/memberLogin"
        let parameters: [String: Any] = ["email": email, "password": password]

        AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let loginResponse):
                    if let jwtToken = loginResponse.jwt {
                        completion(.success(jwtToken))
                    } else  {
                        let authError = AuthError.apiError(code: loginResponse.code ?? "AuthError", message: loginResponse.message ?? "AuthError!!")
                        completion(.failure(authError))
                    }

                case .failure(let error):
                    completion(.failure(.networkError(error)))
                }
            }
    }
}
