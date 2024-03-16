//
//  MainManager.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2/20/24.
//

import Foundation
import Alamofire

class MainManager {
    private let session: Session
    
    init(session: Session = Session.default) {
        self.session = session
    }
    
    func tempToken() {
        let urlString = "http://3.25.115.208:8080/member/reissueToken"
        let parameters: [String: Any] = ["email": "email", "password": "password", "nickname": "nickname", "phone": "phone"]
        let headers: HTTPHeaders =  [
            "Content-Type": "application/json",
            "Authorization": "",
            "Refresh": ""
        ]
        
//        session.request(urlString,
//                        method: .post,
//                        headers: headers,
//                        encoding: URLEncoding.default)
                        
//        session.request(urlString, method: .post, headers: headers, encoding: JSONEncoding.default)
        
        
//        session.request(url,
//                        method: .get,
//                        parameters: parameters,
//                        encoding: URLEncoding.default)
//        .validate(statusCode: 200..<300)
//        .responseData { response in
//            switch response.result {
//            case .success:
//                print("성공")
//            case .failure:
//                print(response.error.debugDescription)
//            }
//        }
        
        
    }
    
    func reissueToken(email: String, password: String, completion: @escaping (Result<String, AuthError>) -> Void) {
        let url = Endpoint.reissueToken.url
        let parameters: [String: Any] = ["email": email, "password": password, "nickname": "nickname", "phone": "phone"]
        let headers: HTTPHeaders =  ["Content-Type": "application/json"]
        
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
                       let authResponse = try? JSONDecoder().decode(AuthenticationResponse.self, from: data) {
                        completion(.failure(.apiError(code: authResponse.code, message: authResponse.message)))
                    } else {
                        completion(.failure(.networkError(error)))
                    }
                }
            }
    }
}

struct MyAuthenticationCredential: AuthenticationCredential {
    let accessToken: String
    let refreshToken: String
    let expiredAt: Date

    // 유효시간이 앞으로 5분 이하 남았다면 refresh가 필요하다고 true를 리턴 (false를 리턴하면 refresh 필요x)
    var requiresRefresh: Bool { Date(timeIntervalSinceNow: 60 * 5) > expiredAt }
}
