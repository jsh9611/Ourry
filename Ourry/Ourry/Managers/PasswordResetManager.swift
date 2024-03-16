//
//  PasswordResetManager.swift
//  Ourry
//
//  Created by SeongHoon Jang on 12/26/23.
//

import Foundation
import Alamofire

class PasswordResetManager {
    private let session: Session
    
    init(session: Session = Session.default) {
        self.session = session
    }
    
    func resetPassword(email: String, newPassword: String, confirmPassword: String, completion: @escaping (Result<String, AuthError>) -> Void) {
        let url = Endpoint.passwordReset.url
        let parameters: [String: Any] = ["email": email, "newPassword": newPassword, "confirmPassword": confirmPassword]
        let headers: HTTPHeaders =  ["Content-Type": "application/json"]
        
        session
            .request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: Empty.self, emptyResponseCodes: [200]) { response in
                switch response.result {
                case .success:
                    // 비밀번호 변경 완료
                    completion(.success("Your password reset has been successful"))
                case .failure(let error):
                    // 비밀번호 변경 실패
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
