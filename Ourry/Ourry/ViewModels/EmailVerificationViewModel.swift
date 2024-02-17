//
//  EmailVerificationViewModel.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2/15/24.
//

import Foundation
import Alamofire

class EmailVerificationViewModel {
    
    private let session: Session
    
    init(session: Session = Session.default) {
        self.session = session
    }
    
    //MARK: - 이메일 인증 요청
    func requestVerificationCode(email: String, completion: @escaping (Result<String, AuthError>) -> Void) {
        let urlString = "http://3.25.115.208:8080/member/sendAuthenticationCode"
        let parameters: [String: Any] = ["email": email]
        let encoding: JSONEncoding = JSONEncoding.default
        let headers: HTTPHeaders =  ["Content-Type": "application/json"]
        
        session
            .request(urlString, method: .post, parameters: parameters, encoding: encoding, headers: headers)
            .validate()
            .responseDecodable(of: Empty.self, emptyResponseCodes: [200]) { response in
                switch response.result {
                case .success:
                    completion(.success("Verification code has been sent to your email"))
                case .failure(let error):
                    // 에러 메세지 확인
                    if let data = response.data,
                       let authResponse = try? JSONDecoder().decode(AuthenticationResponse.self, from: data) {
                        completion(.failure(.apiError(code: authResponse.code, message: authResponse.message)))
                    } else {
                        completion(.failure(.networkError(error)))
                    }
                }
            }
    }
    
    //MARK: - 인증 요청 확인
    func verifyCode(email: String, code: String, completion: @escaping (Result<String, AuthError>) -> Void) {
        let urlString = "http://3.25.115.208:8080/member/emailAuthentication"
        let parameters: [String: Any] = ["email": email, "code": code]
        
        session.request(urlString,
                        method: .post,
                        parameters: parameters,
                        encoding: JSONEncoding.default,
                        headers: ["Content-Type": "application/json"])
        .validate(statusCode: 200..<300)
        .response { response in
            switch response.result {
            case .success:
                // 인증 성공
                completion(.success("Email verification successful"))
            case .failure(let error):
                // 인증실패
                if let data = response.data,
                   let authResponse = try? JSONDecoder().decode(AuthenticationResponse.self, from: data) {
                    completion(.failure(.apiError(code: authResponse.code, message: authResponse.message)))
                } else {
                    completion(.failure(.networkError(error)))
                }
            }
        }
    }
}

struct AuthenticationResponse: Codable {
    let code: String
    let message: String
}

