//
//  CreateAccountManager.swift
//  Ourry
//
//  Created by SeongHoon Jang on 12/26/23.
//

import Foundation
import Alamofire

enum CreateAccountResult {
    case success(jwtToken: String)
    case failure(error: AuthError)
}

class CreateAccountManager {
    static let shared = CreateAccountManager()

    func checkEmailAvailability(email: String, completion: @escaping (Result<CheckEmailAvailabilityResponse, Error>) -> Void) {
        let urlString = "http://localhost:8080/check-email-availability"
        let parameters: [String: Any] = ["email": email]

        AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: CheckEmailAvailabilityResponse.self) { response in
                switch response.result {
                case .success(let availabilityResponse):
                    completion(.success(availabilityResponse))

                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    func completeRegistration(email: String, password: String, nickname: String, completion: @escaping (Result<String, AuthError>) -> Void) {
        let urlString = "http://localhost:8080/complete-registration"
        let parameters: [String: Any] = ["email": email, "password": password, "nickname": nickname]

        AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: RegistrationResponse.self) { response in
                switch response.result {
                case .success(let registrationResponse):
                    if let jwtToken = registrationResponse.jwt {
                        completion(.success(jwtToken))
                    } else {
                        if let code = registrationResponse.code,
                           let message = registrationResponse.message {
                            let authError = AuthError.apiError(code: code, message: message)
                            completion(.failure(authError))
                        } else {
                            completion(.failure(.parsingError))
                        }
                    }

                case .failure(let error):
                    completion(.failure(.networkError(error)))
                }
            }
    }
}

struct CheckEmailAvailabilityResponse: Decodable {
    let memberId: Int?
}

struct RegistrationResponse: Decodable {
    let jwt: String?
    let code: String?
    let message: String?
}
