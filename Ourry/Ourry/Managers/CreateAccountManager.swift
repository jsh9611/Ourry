//
//  CreateAccountManager.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2/17/24.
//

import Foundation
import Alamofire

class CreateAccountManager {
    private let session: Session
    
    init(session: Session = Session.default) {
        self.session = session
    }
    
    func registration(email: String, password: String, nickname: String, phone: String, completion: @escaping (Result<String, AuthError>) -> Void) {
        let url = Endpoint.signup.url
        let parameters: [String: Any] = ["email": email, "password": password, "nickname": nickname, "phone": phone]
        // 데이터 저장을 위한 Mock Token
        let headers: HTTPHeaders =  [
            "FirebaseCloudMessaging": "FirebaseCloudMessaging : eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzdGg0ODgxQG5hdmVyLmNvbSIsIkF1dGhvcml6YXRpb24iOiJST0xFX1VTRVIiLCJpYXQiOjE3MDU4NDg3MjksImV4cCI6MTcwNTg0ODczMH0.D2sLQjfyUCZSaRPDDDF_ll9QVTOcXZfnF6uSSuwVK6w"
        ]
        
        session
            .request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: Empty.self, emptyResponseCodes: [200]) { response in
                switch response.result {
                case .success:
                    // 계정 생성 완료
                    completion(.success("Your account creation has been successful"))
                case .failure(let error):
                    // 개정 생성 실패
                    // 에러 메세지 확인
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
