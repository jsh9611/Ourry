//
//  PasswordResetManager.swift
//  Ourry
//
//  Created by SeongHoon Jang on 12/26/23.
//

import Foundation
import Alamofire

class PasswordResetManager {
    static let shared = PasswordResetManager()

    // 이메일로 인증 코드 발송하는 기능
    func sendAuthenticationCode(email: String, completion: @escaping (Result<String, AuthError>) -> Void) {
        let urlString = "http://localhost:8080/member/sendAuthenticationCode"
        let parameters: [String: Any] = ["email": email]

        AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: PasswordResetResponse.self) { response in
                switch response.result {
                case .success(let authenticationCodeResponse):
                    if authenticationCodeResponse.result == "SUCCESS" {
                        completion(.success("Authentication code sent successfully"))
                    } else {
                        if let code = authenticationCodeResponse.code,
                           let message = authenticationCodeResponse.message {
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

    // 이메일에 온 코드를 입력해서 검증 완료하는 기능
    func verifyResetCode(email: String, code: String, completion: @escaping (Result<String, AuthError>) -> Void) {
        let urlString = "http://localhost:8080/member/emailAuthentication"
        let parameters: [String: Any] = ["email": email, "code": code]

        AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: PasswordResetResponse.self) { response in
                switch response.result {
                case .success(let authenticationCodeResponse):
                    if authenticationCodeResponse.result == "SUCCESS" {
                        completion(.success("Authentication code is verified successfully"))
                    } else {
                        if let code = authenticationCodeResponse.code,
                           let message = authenticationCodeResponse.message {
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

    // 새로운 비밀번호로 변경하는 기능
    func resetPassword(email: String, newPassword: String, confirmPassword: String, completion: @escaping (Result<String, AuthError>) -> Void) {
        let urlString = "http://localhost:8080/member/passwordReset"
        let parameters: [String: Any] = ["email": email, "newPassword": newPassword, "confirmPassword": confirmPassword]

        AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: PasswordResetResponse.self) { response in
                switch response.result {
                case .success(let authenticationCodeResponse):
                    if authenticationCodeResponse.result == "SUCCESS" {
                        completion(.success("Authentication code is verified successfully"))
                    } else {
                        if let code = authenticationCodeResponse.code,
                           let message = authenticationCodeResponse.message {
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

struct PasswordResetResponse: Decodable {
    let result: String
    let code: String?
    let message: String?
}
