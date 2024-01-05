//
//  LoginManager.swift
//  Ourry
//
//  Created by SeongHoon Jang on 12/16/23.
//

import Foundation
import Alamofire

class LoginManager {
    
    private let session: Session
    
    init(session: Session = Session.default) {
        self.session = session
    }
    
    func login(email: String, password: String, completion: @escaping (Result<String, AuthError>) -> Void) {
        let urlString = "http://localhost:8080/member/memberLogin"
        let parameters: [String: Any] = ["email": email, "password": password]

        session.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let loginResponse):
                    if let jwtToken = loginResponse.jwt {
                        completion(.success(jwtToken))
                    } else  {
                        let authError = AuthError.apiError(
                            code: loginResponse.code ?? "M000",
                            message: loginResponse.message ?? "Empty value!!"
                        )
                        completion(.failure(authError))
                    }

                case .failure(let error):
                    completion(.failure(.networkError(error)))
                }
            }
    }
}
