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
    
    //MARK: - 로그인하기
    func login(email: String, password: String, completion: @escaping (Result<String, AuthError>) -> Void) {
        let url = Endpoint.login.url
        let parameters: [String: Any] = ["email": email, "password": password]
        
        session
            .request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Empty.self, emptyResponseCodes: [200]) { response in
                switch response.result {
                case .success:
                    // 로그인 성공
                    if let httpResponse = response.response,
                       let authorization = httpResponse.headers["Authorization"],
                       let refresh = httpResponse.headers["Refresh"] {
                        
                        //키체인에 JWT 토큰 저장 로직을 추가
                        KeychainHelper.create(token: authorization, forAccount: "access_token")
                        KeychainHelper.create(token: refresh, forAccount: "refresh_token")
                        
                        completion(.success(authorization))
                    } else {
                        // 에러 메세지 확인
                        if let data = response.data,
                           let authResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                            completion(.failure(.apiError(code: authResponse.code, message: authResponse.message)))
                        } else {
                            completion(.failure(.parsingError))
                        }
                    }
                case .failure(let error):
                    if let data = response.data,
                       let authResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        completion(.failure(.apiError(code: authResponse.code, message: authResponse.message)))
                    } else {
                        completion(.failure(.networkError(error)))
                    }
                }
            }
    }
}
